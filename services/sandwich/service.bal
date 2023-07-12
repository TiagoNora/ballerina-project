import ballerina/http;
import sandwich.model;
import sandwich.serviceSandwich;
import sandwich.repository;
import ballerinax/rabbitmq;
service /sandwiches on new http:Listener(8091) {

    isolated resource function post .(@http:Payload model:SandwichDTO sand) returns model:ServiceError|model:Sandwich|error|model:NotFoundError|model:ValidationError{
        return serviceSandwich:addSandwich(sand);
    }
    
    isolated resource function get searchById(int id) returns model:Sandwich?|error|model:NotFoundError {
        return serviceSandwich:getSandwichById(id);
    }
    
    isolated resource function get .() returns model:Sandwich[]|error?|model:NotFoundError {
        return serviceSandwich:getAllSandwiches();
    }

    isolated resource function post ingredients(@http:Payload model:Ns ns, int id) returns model:Sandwich|error|model:NotFoundError|model:ValidationError{
        return serviceSandwich:addIngredients(ns,id);
    }

    isolated resource function post descriptions(@http:Payload model:DescriptionsDTO des,int id) returns model:ServiceError|model:Sandwich|error|model:NotFoundError|model:ValidationError{
        return serviceSandwich:addDescriptions(des,id);
    }

    isolated resource function get searchWithoutId(int id) returns model:Sandwich[]|error|model:NotFoundError{
        return serviceSandwich:getWithoutId(id);
    }

}

service "IngredientQueue" on new rabbitmq:Listener(rabbitmq:DEFAULT_HOST, rabbitmq:DEFAULT_PORT) {

    remote function onMessage(model:IngredientDTO ingredient) returns error? {
        _ = check repository:addIngredient(ingredient);
    }
}
