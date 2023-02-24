import ballerina/http;
import ingredient.model;
import ingredient.repository;
service /ingredients on new http:Listener(8080) {

    isolated resource function post .(@http:Payload model:IngredientDTO ing) returns error?|int|model:ValidationError|model:NotFoundError{
        return repository:addIngredient(ing);
    }
    
    isolated resource function get [int id]() returns model:Ingredient?|error|model:NotFoundError {
        return repository:getIngredient(id);
    }
    
    isolated resource function get .() returns model:Ingredient[]|error?|model:NotFoundError {
        return repository:getAllIngredients();
    }

}