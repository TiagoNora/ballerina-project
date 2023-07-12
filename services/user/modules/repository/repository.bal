import ballerinax/mysql;
import ballerinax/mysql.driver as _; 
import ballerina/sql;
import user.model;
import ballerina/regex;
import ballerina/jwt;
import ballerinax/rabbitmq;


configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;

final mysql:Client dbClient;
final rabbitmq:Client rabbitmqClient;

function init() returns error? {
    rabbitmqClient = check new(rabbitmq:DEFAULT_HOST, rabbitmq:DEFAULT_PORT);
    _ = check rabbitmqClient->exchangeDeclare("user", rabbitmq:FANOUT_EXCHANGE);
    _ = check rabbitmqClient->queueDeclare("users");
    _ = check rabbitmqClient->queueBind("users", "user", "routingUser");
    mysql:Client dbClientCreate = check new(host=HOST, user=USER, password=PASSWORD, port=PORT);
    sql:ExecutionResult _ = check dbClientCreate->execute(`CREATE DATABASE IF NOT EXISTS Users`);
    check dbClientCreate.close();

    dbClient = check new(host=HOST, user=USER, password=PASSWORD, port=PORT, database="Users"); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Users.users (
                                                    user_id INT NOT NULL AUTO_INCREMENT, 
                                                    name VARCHAR(255),
                                                    password VARCHAR(255),
                                                    taxIdentificationNumber VARCHAR(255),
                                                    address VARCHAR(255),
                                                    email VARCHAR(255),
                                                    PRIMARY KEY (user_id, email))`); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Users.users_perms (
                                                    user_id INT NOT NULL, 
                                                    perm VARCHAR(255), 
                                                    PRIMARY KEY (user_id, perm), 
                                                    FOREIGN KEY (user_id) REFERENCES users(user_id))`);                                
}

public isolated function addUser(model:UserDTO user) returns model:User?|error|model:NotFoundError|model:ValidationError{
    string regex = "^([a-z0-9_+]([a-z0-9_+.]*[a-z0-9_+])?)@([a-z0-9]+([\\-\\.]{1}[a-z0-9]+)*\\.[a-z]{2,6})";
    boolean isMatched = regex:matches(user.email, regex);
    if isMatched is false{
        return validationError("INVALID_EMAIL","The introduzed email is not valid");
    }

    if user.taxIdentificationNumber.length() != 9{
        return validationError("INVALID_TAX_IDENTIFICATION_NUMBER","The introduzed tax identification number is not valid");
    }

    model:User|model:NotFoundError r1 = getUserByEmail(user.email);
    if r1 is model:User{
        return validationError("EMAIL_ALREADY_REGISTRED","The introduzed email is not valid");
    }
    model:User|model:NotFoundError r2 = getUserByTaxIdentificationNumber(user.taxIdentificationNumber);
    if r2 is model:User{
        return validationError("TAX_IDENTIFICATION_NUMBER_ALREADY_REGISTRED","The introduzed tax identification number is not valid");
    }
    int|model:NotFoundError|error lastIdInserted = addUserToDB(user);
    int n=0;
    if lastIdInserted is int{
        n=lastIdInserted;
    }

    model:User|model:NotFoundError r = getUserById(n);
    if r is model:User{
        check rabbitmqClient->publishMessage({content: r, routingKey: "users"});
    }

    return r;

}

public isolated function addRabbit(model:User r) returns error?{
    _ = check rabbitmqClient->publishMessage({content: r, routingKey: "users"});
}

public isolated function addUserToDB(model:UserDTO user) returns int|model:NotFoundError|error{
    sql:ExecutionResult result = check dbClient->execute(`INSERT INTO users (name, password, taxIdentificationNumber,address,email) VALUES (${user.name}, ${user.password}, ${user.taxIdentificationNumber},${user.address},${user.email})`);
    int|string? lastInsertId = result.lastInsertId;
    string default = "CUSTOMER";
    if lastInsertId is int{
        sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO users_perms (user_id, perm) VALUES (${lastInsertId}, ${default})`);
        return lastInsertId;
    }
    else {
        return notFound("USER_ID_NOT_FOUND","The searched user has not founded");
    }

}

public isolated function addPerm(int id, string perm) returns error?{
    _ = check dbClient->execute(`INSERT INTO users_perms (user_id, perm) VALUES (${id}, ${perm})`);
}

public isolated function getUserById(int id) returns model:User|model:NotFoundError{
    model:User|error r = getUserByIdFromDB(id);
    if r is error{
        return notFound("QUERY_ERROR","To the given id no useres were found");
    }
    string[]|error array = findUserPermsByIdFromDB(id);
    if array is error{
        return notFound("QUERY_ERROR","To the given id no perms were found");
    }
    model:User u = {
        user_id: id,
        name:r.name,
        taxIdentificationNumber: r.taxIdentificationNumber,
        address: r.address,
        email: r.email,
        permissions: array
    };
    return u;
}

public isolated function getUserByEmail(string mail) returns model:User|model:NotFoundError{
    model:User|error r = getUserByEmailFromDB(mail);
    if r is error{
        return notFound("QUERY_ERROR","To the given email no users were found");
    }
    string[]|error array = findUserPermsByIdFromDB(r.user_id);
    if array is error{
        return notFound("QUERY_ERROR","To the given id no perms were found");
    }
    model:User u = {
        user_id: r.user_id,
        name:r.name,
        taxIdentificationNumber: r.taxIdentificationNumber,
        address: r.address,
        email: r.email,
        permissions: array
    };
    return u;
}

public isolated function getUserByTaxIdentificationNumber(string tax) returns model:User|model:NotFoundError{
    model:User|error r = getUserByTaxIdentFromDB(tax);
    if r is error{
        return notFound("QUERY_ERROR","To the given tax identification number no users were found");
    }
    string[]|error array = findUserPermsByIdFromDB(r.user_id);
    if array is error{
        return notFound("QUERY_ERROR","To the given id no perms were found");
    }
    model:User u = {
        user_id: r.user_id,
        name:r.name,
        taxIdentificationNumber: r.taxIdentificationNumber,
        address: r.address,
        email: r.email,
        permissions: array
    };
    return u;
}

public isolated function checkUserById(int id) returns boolean{
    model:User|error ing = getUserByIdFromDB(id);
    if ing is error{
           return false;
    }
    else {
        return true;
    }
}

public isolated function checkUserDetails(model:Login login) returns boolean{
    model:User|error ing = getUserDetailsFromDB(login);
    if ing is error{
           return false;
    }
    else {
        return true;
    }
}

public isolated function getUserDetailsFromDB(model:Login login) returns model:User|error{
    model:User|error ing = check dbClient->queryRow(
        `SELECT * FROM users WHERE email = ${login.email} and password = ${login.password}`
    );
    return ing;
}

public isolated function checkUserPermById(int id) returns boolean{
    string|error ing = getPermFromDB(id);
    if ing is error{
           return false;
    }
    else {
        return true;
    }
}

public isolated function getPermFromDB(int id) returns string|error{
    string perm = "ADMIN";
    string|error ing = check dbClient->queryRow(
        `SELECT perm FROM users_perms WHERE perm = ${perm} and user_id = ${id}`
    );
    return ing;
}

public isolated function getUserByIdFromDB(int id) returns model:User|error{
    model:User|error ing = check dbClient->queryRow(
        `SELECT * FROM users WHERE user_id = ${id}`
    );
    return ing;
}

public isolated function getUserByEmailFromDB(string mail) returns model:User|error{
    model:User|error ing = check dbClient->queryRow(
        `SELECT * FROM users WHERE email = ${mail}`
    );
    return ing;
}

public isolated function getUserByTaxIdentFromDB(string tax) returns model:User|error{
    model:User|error ing = check dbClient->queryRow(
        `SELECT * FROM users WHERE taxIdentificationNumber = ${tax}`
    );
    return ing;
}

public isolated function findUserPermsByIdFromDB(int id) returns string[]|error{
    model:N[] array = [];
    string[] arrayString = [];
    stream<model:N, sql:Error?> resultStream = dbClient->query(`SELECT perm FROM users_perms WHERE user_id  = ${id}`);
    check from model:N des in resultStream
        do {
            array.push(des);
        };
    check resultStream.close();
    foreach model:N n in array {
        arrayString.push(n.perm);
    }
    return arrayString;
}

public isolated function getAutenticationDataFromUser(int id) returns model:Roles?|error|model:NotFoundError{
    model:User|error r = getUserByIdFromDB(id);
    if r is error{
        return notFound("QUERY_ERROR","To the given id no useres were found");
    }
    string[]|error array = findUserPermsByIdFromDB(id);
    if array is error{
        return notFound("QUERY_ERROR","To the given id no perms were found");
    }
    model:Roles roles = {
        perms: array
    };
    return roles;
}

public isolated function getAllUsers() returns model:User[]|error?|model:NotFoundError{
    model:User[] users = [];
    int[]|error array = findUsersByIdsFromDB();
    if array is error{
        return notFound("USERS_NOT_FOUND","No users were found");
    }
    foreach int n in array {
        model:User?|error|model:NotFoundError sand = getUserById(n);
        users.push(<model:User>check sand);
    }
    return users;
}

public isolated function findUsersByIdsFromDB() returns int[]|error{
    model:User[] infos = [];
    int[] array = [];
    stream<model:User, sql:Error?> resultStream = dbClient->query(`SELECT * from users`);
    check from model:User info in resultStream
        do {
            infos.push(info);
        };
    check resultStream.close();
    foreach model:User n in infos {
        array.push(n.user_id);
        
    }
    return array;
}

public isolated function addPermissionToUser(int id) returns model:User|model:NotFoundError|error|model:ValidationError{
    boolean flag = checkUserById(id);
    boolean flag1 = checkUserPermById(id);
    string perm = "ADMIN";
    if flag == false{
        return notFound("USER_ID_NOT_FOUND","The searched user has not founded");
    }
    if flag1 == true{
        return validationError("DUPLICATED_PERM","The user already have that permission");
    }
    sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO users_perms (user_id, perm) VALUES (${id}, ${perm})`);
    model:User|model:NotFoundError r = getUserById(id);
    return r;


}

public isolated function jwt(model:Login login) returns model:NotFoundError|string{
    boolean flag = checkUserDetails(login);
        if flag == false{
        return notFound("USER_NOT_FOUND","The user has not founded");
    }
    model:User|error r = getUserByEmailFromDB(login.email);
    if r is error{
        return notFound("QUERY_ERROR","To the given email no users were found");
    }
    string[]|error array = findUserPermsByIdFromDB(r.user_id);
    if array is error{
        return notFound("QUERY_ERROR","To the given id no perms were found");
    }
    json userDetails = {"id": r.user_id,"roles":array};
    jwt:IssuerConfig issuerConfig = {
        customClaims: <map<json>> userDetails,
        issuer: "userApplication",
        expTime: 3600,
        signatureConfig: {
            config: {
                keyFile: "../perms/private.key"
            }
        }
    };
    string|error jwt = jwt:issue(issuerConfig);
    if jwt is error{
        return notFound("JWT_ERROR","Error when creating jwt");
    }
    return jwt;
}


public isolated function notFound(string codeMessage,string messageError) returns model:NotFoundError{
    return <model:NotFoundError>{
            body: {
                'error: {
                    code: codeMessage,
                    message: messageError
                }
            }
               
    };
}

public isolated function validationError(string codeMessage,string messageError) returns model:ValidationError{
    return <model:ValidationError>{
            body: {
                'error: {
                    code: codeMessage,
                    message: messageError
                }
            }
               
    };
}