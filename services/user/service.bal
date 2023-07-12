import ballerina/http;
import user.model;
import user.serviceUser;
service /users on new http:Listener(8092) {

    isolated resource function post .(@http:Payload model:UserDTO user) returns model:User?|error|model:NotFoundError|model:ValidationError{
        return serviceUser:addUser(user);
    }

    isolated resource function get searchById(int id) returns model:User?|error|model:NotFoundError {
        return serviceUser:getUserById(id);
    }

    isolated resource function get searchByEmail(string email) returns model:User?|error|model:NotFoundError {
        return serviceUser:getUserByEmail(email);
    }

    isolated resource function get searchByTaxIdentificationNumber(string tax) returns model:User?|error|model:NotFoundError {
        return serviceUser:getUserByTaxIdentificationNumber(tax);
    }

    isolated resource function get autenticationData(int id) returns model:Roles?|error|model:NotFoundError {
        return serviceUser:getAutenticationDataFromUser(id);
    }

    isolated resource function get .() returns model:User[]|error?|model:NotFoundError {
        return serviceUser:getAllUsers();
    }

    isolated resource function post permissions(int id) returns error|model:ValidationError|model:User?|model:NotFoundError{
        return serviceUser:addPermissionToUser(id);
    }

    isolated resource function post jwt(@http:Payload model:Login login) returns model:NotFoundError|string{
        return serviceUser:jwt(login);
    }

    

}