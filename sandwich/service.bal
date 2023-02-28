import ballerina/http;
import sandwich.model;
import sandwich.repository;
service /sandwiches on new http:Listener(8081) {

    isolated resource function post .(@http:Payload model:SandwichDTO sand) returns error|model:ValidationError|model:Sandwich?|model:NotFoundError{
        return repository:addSandwich(sand);
    }
    
    isolated resource function get searchById(int id) returns model:Sandwich?|error|model:NotFoundError {
        return repository:getSandwichById(id);
    }
    
    isolated resource function get .() returns model:Sandwich[]|error?|model:NotFoundError {
        return repository:getAllSandwiches();
    }

    isolated resource function post ingredients(@http:Payload model:Ns ns, int id) returns model:Sandwich|error|model:NotFoundError|model:ValidationError{
        return repository:addIngredients(ns,id);
    }

    //Add descriptions ao sandwich
    //List all sandwiches that doesn´t have a ingredient

}
