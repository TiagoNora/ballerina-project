import ballerinax/mysql;
import ballerinax/mysql.driver as _; 
import ballerina/sql;
import user.model;
import ballerina/regex;

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;

final mysql:Client dbClient;

function init() returns error? {
    mysql:Client dbClientCreate = check new(host=HOST, user=USER, password=PASSWORD, port=PORT);
    sql:ExecutionResult _ = check dbClientCreate->execute(`CREATE DATABASE IF NOT EXISTS User`);
    check dbClientCreate.close();

    dbClient = check new(host=HOST, user=USER, password=PASSWORD, port=PORT, database="User"); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS User.users (
                                                    user_id INT NOT NULL AUTO_INCREMENT, 
                                                    name VARCHAR(255),
                                                    password VARCHAR(255),
                                                    taxIdentificationNumber VARCHAR(255),
                                                    address VARCHAR(255),
                                                    email VARCHAR(255),
                                                    PRIMARY KEY (user_id, email))`); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS User.users_perms (
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
    int|model:NotFoundError|error lastIdInserted = addUserToDB(user);
    int n=0;
    if lastIdInserted is int{
        n=lastIdInserted;
    }

    model:User|model:NotFoundError r = getUserById(n);

    return r;

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

public isolated function checkUserById(int id) returns boolean{
    model:User|error ing = getUserByIdFromDB(id);
    if ing is error{
           return false;
    }
    else {
        return true;
    }
}

public isolated function getUserByIdFromDB(int id) returns model:User|error{
    model:User|error ing = check dbClient->queryRow(
        `SELECT * FROM users WHERE user_id = ${id}`
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