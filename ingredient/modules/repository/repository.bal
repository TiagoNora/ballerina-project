import ballerinax/mysql;
import ballerinax/mysql.driver as _; 
import ballerina/sql;
import ingredient.model;

string USER = "myUser";
string PASSWORD = "myPassword";
string HOST = "localhost";
int PORT = 3306;

final mysql:Client dbClient;

function init() returns error? {
    mysql:Client dbClientCreate = check new(host=HOST, user=USER, password=PASSWORD, port=PORT);
    sql:ExecutionResult _ = check dbClientCreate->execute(`CREATE DATABASE IF NOT EXISTS Ingredient`);
    check dbClientCreate.close();

    dbClient = check new(host=HOST, user=USER, password=PASSWORD, port=PORT, database="Ingredient"); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Ingredient.Ingredients (
                                           ingredient_id INT AUTO_INCREMENT,
                                           designation VARCHAR(255), 
                                           PRIMARY KEY (ingredient_id)
                                         )`);                                
}

public isolated function addIngredient(model:IngredientDTO ing) returns error|model:ValidationError|model:Ingredient?|error|model:NotFoundError|model:NotFoundError{
    model:Ingredient|error verification = checkIngredient(ing.designation);
    if verification is model:Ingredient{
        return validationError("INGREDIENT_ALREADY_EXISTS","The ingredient has already created");
    }
    sql:ExecutionResult result = check dbClient->execute(`
    INSERT INTO Ingredients (designation)
    VALUES (${ing.designation})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return getIngredientById(lastInsertId);
    } else {
        return notFound("INGREDIENT_ID_NOT_FOUND","The searched ingredient has not founded");
    }
}

public isolated function getIngredientById(int id) returns model:Ingredient?|error|model:NotFoundError{
    model:Ingredient|error ing = getIngredientByIdFromDB(id);
    if ing is error{
           return notFound("INGREDIENT_NOT_FOUND","The searched ingredient has not founded");
    }
    else {
        return ing;
    }
}

public isolated function getIngredientByDesignation(string designation) returns model:Ingredient?|error|model:NotFoundError{
    model:Ingredient|error ing = getIngredientByDesignationFromDB(designation);
    if ing is error{
           return notFound("INGREDIENT_NOT_FOUND","The searched ingredient has not founded");
    }
    else {
        return ing;
    }
}

public isolated function getAllIngredients() returns model:Ingredient[]|error?|model:NotFoundError {
    model:Ingredient[] ingredients = [];
    stream<model:Ingredient, sql:Error?> resultStream = dbClient->query(
        `SELECT * FROM Ingredients`
    );
    check from model:Ingredient ing in resultStream
        do {
            ingredients.push(ing);
        };
    check resultStream.close();
    if ingredients.length() == 0{
        return notFound("INGREDIENTS_NOT_FOUND","The searched ingredients has not founded");
    }

    return ingredients;
}

public isolated function checkIngredient(string designation) returns model:Ingredient|error{
    model:Ingredient|error ing = check dbClient->queryRow(
        `SELECT * FROM Ingredients WHERE designation = ${designation}`
    );
    return ing;
}

public isolated function getIngredientByIdFromDB(int id) returns model:Ingredient|error{
    model:Ingredient|error ing = check dbClient->queryRow(
        `SELECT * FROM Ingredients WHERE ingredient_id = ${id}`
    );
    return ing;
}

public isolated function getIngredientByDesignationFromDB(string designation) returns model:Ingredient|error{
    model:Ingredient|error ing = check dbClient->queryRow(
        `SELECT * FROM Ingredients WHERE designation = ${designation}`
    );
    return ing;
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