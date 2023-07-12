import ingredient.repository;
import ingredient.model;
public isolated function addIngredient(model:IngredientDTO ing) returns error|model:ValidationError|model:Ingredient?|error|model:NotFoundError|model:NotFoundError{
    model:Ingredient|error verification = repository:checkIngredient(ing.designation);
    if verification is model:Ingredient{
        return validationError("INGREDIENT_ALREADY_EXISTS","The ingredient has already created");
    }
    int|model:NotFoundError|error id = repository:addIngredient(ing);
    if id is int {
        return getIngredientById(id);
    } else {
        return notFound("INGREDIENT_ID_NOT_FOUND","The searched ingredient has not founded");
    }
}

public isolated function getIngredientById(int id) returns model:Ingredient?|error|model:NotFoundError{
    model:Ingredient|error ing = repository:getIngredientByIdFromDB(id);
    if ing is error{
           return notFound("INGREDIENT_NOT_FOUND","The searched ingredient has not founded");
    }
    else {
        return ing;
    }
}

public isolated function getIngredientByDesignation(string designation) returns model:Ingredient?|error|model:NotFoundError{
    model:Ingredient|error ing = repository:getIngredientByDesignationFromDB(designation);
    if ing is error{
           return notFound("INGREDIENT_NOT_FOUND","The searched ingredient has not founded");
    }
    else {
        return ing;
    }
}

public isolated function getAllIngredients() returns model:Ingredient[]|error?|model:NotFoundError {
    return repository:getAllIngredients();
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