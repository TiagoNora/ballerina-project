import ballerinax/mysql;
import ballerinax/mysql.driver as _; 
import ballerina/sql;
import ingredient.model;

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;

mysql:Client dbClient;

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

public function addIngredient(model:IngredientDTO ing) returns int|error{
    model:Ingredient|error verification = checkIngredient(ing.designation);
    if verification is model:Ingredient{
        return error("Duplicated ingredient");
    }
    sql:ExecutionResult result = check dbClient->execute(`
    INSERT INTO Ingredients (designation)
    VALUES (${ing.designation})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
}

public function getIngredient(int id) returns model:Ingredient|error{
    model:Ingredient|sql:Error ing = check dbClient->queryRow(
        `SELECT * FROM Ingredients WHERE ingredient_id = ${id}`
    );
    return ing;
}

public function getAllIngredients() returns model:Ingredient[]|error {
    model:Ingredient[] ingredients = [];
    stream<model:Ingredient, sql:Error?> resultStream = dbClient->query(
        `SELECT * FROM Ingredients`
    );
    check from model:Ingredient ing in resultStream
        do {
            ingredients.push(ing);
        };
    check resultStream.close();
    return ingredients;
}

public function checkIngredient(string designation) returns model:Ingredient|error{
    model:Ingredient|sql:Error ing = check dbClient->queryRow(
        `SELECT * FROM Ingredients WHERE designation = ${designation}`
    );
    return ing;
}
