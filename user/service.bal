import ballerina/http;
import user.model;
import user.repository;
service /users on new http:Listener(8081) {

    isolated resource function post .(@http:Payload model:UserDTO sand) returns error|model:ValidationError|model:User?|model:NotFoundError{
        return repository:addUser(sand);
    }
    
    isolated resource function get searchById(int id) returns model:User?|error|model:NotFoundError {
        return repository:getUserById(id);
    }
    
    isolated resource function get searchByEmail(string email) returns model:User?|error|model:NotFoundError {
        return repository:getUserByEmail(id);
    }

    isolated resource function get searchByTaxIdentificationNumber(int id) returns model:User?|error|model:NotFoundError {
        return repository:getUserByTaxIdentificationNumber(id);
    }

    isolated resource function get autenticationData(int id) returns model:AuthenticationData?|error|model:NotFoundError {
        return repository:getautenticationDataFromUser(id);
    }
    
    isolated resource function get .() returns model:User[]|error?|model:NotFoundError {
        return repository:getAllUsers();
    }

    isolated resource function post permissions(@http:Payload model:UserDTO sand, int id) returns error|model:ValidationError|model:User?|model:NotFoundError{
        return repository:addPermissionToUser(sand);
    }

}