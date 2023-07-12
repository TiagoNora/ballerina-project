import ballerina/http;
import ingredient.model;
import ingredient.ingredientService;
service /ingredients on new http:Listener(8090) {

    isolated resource function post .(@http:Payload model:IngredientDTO ing) returns error|model:ValidationError|model:Ingredient?|model:NotFoundError{
        return ingredientService:addIngredient(ing);
    }
    
    isolated resource function get searchById(int id) returns model:Ingredient?|error|model:NotFoundError {
        return ingredientService:getIngredientById(id);
    }

    isolated resource function get searchByDesignation(string designation) returns model:Ingredient?|error|model:NotFoundError {
        return ingredientService:getIngredientByDesignation(designation);
    }
    
    isolated resource function get .() returns model:Ingredient[]|error?|model:NotFoundError {
        return ingredientService:getAllIngredients();
    }

}