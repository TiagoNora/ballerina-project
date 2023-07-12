import user.model;
import ballerina/regex;
import ballerina/jwt;
import user.repository;
public isolated function addUser(model:UserDTO user) returns model:User?|error|model:NotFoundError|model:ValidationError{
    string regex = "^([a-z0-9_+]([a-z0-9_+.]*[a-z0-9_+])?)@([a-z0-9]+([\\-\\.]{1}[a-z0-9]+)*\\.[a-z]{2,6})";
    boolean isMatched = regex:matches(user.email, regex);
    if isMatched is false{
        return validationError("INVALID_EMAIL","The introduzed email is not valid");
    }

    if user.taxIdentificationNumber.length() != 9{
        return validationError("INVALID_TAX_IDENTIFICATION_NUMBER","The introduzed tax identification number is not valid");
    }

    model:User|model:NotFoundError r1 = repository:getUserByEmail(user.email);
    if r1 is model:User{
        return validationError("EMAIL_ALREADY_REGISTRED","The introduzed email is not valid");
    }
    model:User|model:NotFoundError r2 = repository:getUserByTaxIdentificationNumber(user.taxIdentificationNumber);
    if r2 is model:User{
        return validationError("TAX_IDENTIFICATION_NUMBER_ALREADY_REGISTRED","The introduzed tax identification number is not valid");
    }
    int|model:NotFoundError|error lastIdInserted = repository:addUserToDB(user);
    int n=0;
    if lastIdInserted is int{
        n=lastIdInserted;
    }

    model:User|model:NotFoundError r = getUserById(n);
    if r is model:User{
        _ = check repository:addRabbit(r);
    }

    return r;

}

public isolated function getUserById(int id) returns model:User|model:NotFoundError{
    model:User|error r = repository:getUserByIdFromDB(id);
    if r is error{
        return notFound("QUERY_ERROR","To the given id no useres were found");
    }
    string[]|error array = repository:findUserPermsByIdFromDB(id);
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
    model:User|error r = repository:getUserByEmailFromDB(mail);
    if r is error{
        return notFound("QUERY_ERROR","To the given email no users were found");
    }
    string[]|error array = repository:findUserPermsByIdFromDB(r.user_id);
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
    model:User|error r = repository:getUserByTaxIdentFromDB(tax);
    if r is error{
        return notFound("QUERY_ERROR","To the given tax identification number no users were found");
    }
    string[]|error array = repository:findUserPermsByIdFromDB(r.user_id);
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

public isolated function getAutenticationDataFromUser(int id) returns model:Roles?|error|model:NotFoundError{
    model:User|error r = repository:getUserByIdFromDB(id);
    if r is error{
        return notFound("QUERY_ERROR","To the given id no useres were found");
    }
    string[]|error array = repository:findUserPermsByIdFromDB(id);
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
    int[]|error array = repository:findUsersByIdsFromDB();
    if array is error{
        return notFound("USERS_NOT_FOUND","No users were found");
    }
    foreach int n in array {
        model:User?|error|model:NotFoundError sand = repository:getUserById(n);
        users.push(<model:User>check sand);
    }
    return users;
}

public isolated function addPermissionToUser(int id) returns model:User|model:NotFoundError|error|model:ValidationError{
    boolean flag = repository:checkUserById(id);
    boolean flag1 = repository:checkUserPermById(id);
    string perm = "ADMIN";
    if flag == false{
        return notFound("USER_ID_NOT_FOUND","The searched user has not founded");
    }
    if flag1 == true{
        return validationError("DUPLICATED_PERM","The user already have that permission");
    }
    _ = check repository:addPerm(id, perm);
    model:User|model:NotFoundError r = repository:getUserById(id);
    return r;


}

public isolated function jwt(model:Login login) returns model:NotFoundError|string{
    boolean flag = repository:checkUserDetails(login);
        if flag == false{
        return notFound("USER_NOT_FOUND","The user has not founded");
    }
    model:User|error r = repository:getUserByEmailFromDB(login.email);
    if r is error{
        return notFound("QUERY_ERROR","To the given email no users were found");
    }
    string[]|error array = repository:findUserPermsByIdFromDB(r.user_id);
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