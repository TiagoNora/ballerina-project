import ballerina/http;
import user.model;
import user.repository;
service /users on new http:Listener(8082) {

    isolated resource function post .(@http:Payload model:UserDTO user) returns model:User?|error|model:NotFoundError|model:ValidationError{
        return repository:addUser(user);
    }

    isolated resource function get searchById(int id) returns model:User?|error|model:NotFoundError {
        return repository:getUserById(id);
    }

    isolated resource function get searchByEmail(string email) returns model:User?|error|model:NotFoundError {
        return repository:getUserByEmail(email);
    }

    isolated resource function get searchByTaxIdentificationNumber(string tax) returns model:User?|error|model:NotFoundError {
        return repository:getUserByTaxIdentificationNumber(tax);
    }

    isolated resource function get autenticationData(int id) returns model:Roles?|error|model:NotFoundError {
        return repository:getAutenticationDataFromUser(id);
    }

    isolated resource function get .() returns model:User[]|error?|model:NotFoundError {
        return repository:getAllUsers();
    }

    //isolated resource function post permissions(@http:Payload model:UserDTO sand, int id) returns error|model:ValidationError|model:User?|model:NotFoundError{
    //    return repository:addPermissionToUser(sand);
    //}
    

}