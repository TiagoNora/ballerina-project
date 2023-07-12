import ballerinax/mysql;
import ballerinax/mysql.driver as _; 
import ballerina/sql;
import ingredient.model;
import ballerinax/rabbitmq;

string USER = "myUser";
string PASSWORD = "myPassword";
string HOST = "localhost";
int PORT = 3306;

final mysql:Client dbClient;
final rabbitmq:Client rabbitmqClient;
function init() returns error? {
    rabbitmqClient = check new(rabbitmq:DEFAULT_HOST, rabbitmq:DEFAULT_PORT);
    _ = check rabbitmqClient->queueDeclare("ingredientes");
    mysql:Client dbClientCreate = check new(host=HOST, user=USER, password=PASSWORD, port=PORT);
    sql:ExecutionResult _ = check dbClientCreate->execute(`CREATE DATABASE IF NOT EXISTS Ingredients`);
    check dbClientCreate.close();

    dbClient = check new(host=HOST, user=USER, password=PASSWORD, port=PORT, database="Ingredients"); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Ingredients.Ingredients (
                                           ingredient_id INT AUTO_INCREMENT,
                                           designation VARCHAR(255), 
                                           PRIMARY KEY (ingredient_id)
                                         )`);                                
}

public isolated function addIngredient(model:IngredientDTO ing) returns int|model:NotFoundError|error{
    sql:ExecutionResult result = check dbClient->execute(`
    INSERT INTO Ingredients (designation)
    VALUES (${ing.designation})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        check rabbitmqClient->publishMessage({content: ing, routingKey: "ingredientes"});
        return lastInsertId;
    } else {
        return notFound("INGREDIENT_ID_NOT_FOUND","The searched ingredient has not founded");
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