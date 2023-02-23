import ballerina/http;
import ingredient.model;
import ingredient.repository;
service /ingredients on new http:Listener(8080) {

    resource function post .(@http:Payload model:IngredientDTO ing) returns int|error{
        return repository:addIngredient(ing);
    }
    
    resource function get [int id]() returns model:Ingredient|error {
        return repository:getIngredient(id);
    }
    
    resource function get .() returns model:Ingredient[]|error {
        return repository:getAllIngredients();
    }

}