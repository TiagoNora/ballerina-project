import ballerinax/mysql;
import ballerinax/mysql.driver as _; 
import ballerina/sql;
import ballerina/http;
import sandwich.model;

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;

final mysql:Client dbClient;

function init() returns error? {
    mysql:Client dbClientCreate = check new(host=HOST, user=USER, password=PASSWORD, port=PORT);
    sql:ExecutionResult _ = check dbClientCreate->execute(`CREATE DATABASE IF NOT EXISTS Sandwich`);
    check dbClientCreate.close();

    dbClient = check new(host=HOST, user=USER, password=PASSWORD, port=PORT, database="Sandwich"); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Sandwich.sandwiches (
                                                    sandwich_id INT NOT NULL AUTO_INCREMENT, 
                                                    selling_price FLOAT(6), 
                                                    designation VARCHAR(30), 
                                                    PRIMARY KEY (sandwich_id)
                                                    )`); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Sandwich.sandwich_ingredients (
                                                    sandwich_id INT NOT NULL, 
                                                    ingredient_id INT NOT NULL, 
                                                    PRIMARY KEY (sandwich_id, ingredient_id), 
                                                    FOREIGN KEY (sandwich_id) REFERENCES sandwiches(sandwich_id)
                                                    )`);
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Sandwich.sandwich_descriptions (
                                                    sandwich_id INT NOT NULL, 
                                                    text VARCHAR(500), 
                                                    language VARCHAR(5), 
                                                    PRIMARY KEY (sandwich_id, language), 
                                                    FOREIGN KEY (sandwich_id) REFERENCES sandwiches(sandwich_id)
                                                    )`);                                    
}

public isolated function addSandwich(model:SandwichDTO san) returns error|model:ValidationError|model:Sandwich?|error|model:NotFoundError{
    if san.ingredients_id.length() == 0{
        return <model:ValidationError>{
            body: {
                'error: {
                    code: "SANDWICH_WITH_NO_INGREDIENTS",
                    message: "The sandwich that has received contains no ingredients"
                }
            }
               
        };
    }
    else {
        if hasDuplicates(san.ingredients_id) == true{
            return <model:ValidationError>{
                body: {
                    'error: {
                    code: "INGREDIENTS_DUPLICATED",
                    message: "One of the ingredients insert into the list is duplicated"
                    }
                }
               
            };
        }
        foreach int n in san.ingredients_id {
            boolean|error flag = findIngredientByIdFromRest(n);
            if flag == false{
                return <model:NotFoundError>{
                    body: {
                        'error: {
                        code: "INGREDIENT_NOT_FOUND",
                        message: "One of the ingredients insert into the list doesn´t exists"
                        }
                    }
               
                };
            }
        }
    }
    if san.descriptions.length() == 0{
        return <model:ValidationError>{
            body: {
                'error: {
                    code: "SANDWICH_WITH_NO_DESCRIPTIONS",
                    message: "The sandwich that has received contains no descriptions"
                }
            }
               
        };
    }

    int|model:NotFoundError|error lastIdInserted = addSandwichToDB(san.selling_price,san.designation);
    int n = 0;
    if lastIdInserted is int{
        n = lastIdInserted;
    }
    foreach int ingrediend_id in san.ingredients_id {
        sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO sandwich_ingredients (sandwich_id, ingredient_id) VALUES (${n}, ${ingrediend_id})`);
    }
    foreach model:Description description in san.descriptions {
        sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO sandwich_descriptions (sandwich_id , text, language) VALUES (${n}, ${description.text}, ${description.language})`);
    }

    model:Sandwich|error|model:NotFoundError sand = getSandwichById(n);

    return sand;
}

public isolated function getSandwichById(int id) returns model:Sandwich|error|model:NotFoundError{
    model:SandwichInfo|error info = findSandwichByIdFromDB(id);
    if info is error{
           return <model:NotFoundError>{
               body: {
                   'error: {
                       code: "SANDWICH_NOT_FOUND",
                       message: "The searched sandwich has not founded"
                   }
               }
           };
    } 
    int[]|error array = findSandwichIngredientsByIdFromDB(id);
    if array is error{
        return <model:NotFoundError>{
            body: {
                'error: {
                    code: "QUERY_ERROR",
                    message: "To the given id no ingredients were found"
                }
            }
        };
    }
    model:Description[]|error descriptions = findSandwichDescriptionsByIdFromDB(id);
    if descriptions is error{
        return <model:NotFoundError>{
            body: {
                'error: {
                    code: "QUERY_ERROR",
                    message: "To the given id no descritpions were found"
                }
            }
        };
    }
    
    model:Sandwich sandwich = {
        sandwich_id: id,
        selling_price: info.selling_price.round(2),
        designation: info.designation,
        ingredients_id: array,
        descriptions: descriptions
    };
    return sandwich;

}

public isolated function getAllSandwiches() returns model:Sandwich[]|error?|model:NotFoundError {
    model:Sandwich[] sandwiches = [];
    int[]|error array = findSandwichByIdsFromDB();
    if array is error{
        return <model:NotFoundError>{
            body: {
                'error: {
                    code: "SANDWICHES_NOT_FOUND",
                    message: "No sandwiches were found"
                }
            }
        };
    }
    foreach int n in array {
        model:Sandwich?|error|model:NotFoundError sand = getSandwichById(n);
        sandwiches.push(<model:Sandwich>check sand);
    }
    return sandwiches;
}

public isolated function addSandwichToDB(float selling_price, string designation) returns int|model:NotFoundError|error{
    sql:ExecutionResult result = check dbClient->execute(`INSERT INTO sandwiches (selling_price, designation) VALUES (${selling_price}, ${designation})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int{
        return lastInsertId;
    }
    else {
        return <model:NotFoundError>{
            body: {
                'error: {
                    code: "INGREDIENT_ID_NOT_FOUND",
                    message: "The searched ingredient has not founded"
                }
            }
               
        };
    }

}

public isolated function findIngredientByIdFromRest(int id) returns boolean|error{
    http:Client ingredientClient = check new ("localhost:8080");
    string r = "/ingredients/searchById?id=" + id.toString();
    http:Response response = check ingredientClient->get(r);
    if response.statusCode == 200{
        return true;
    }
    else {
        return false;
    }
}

public isolated function findSandwichByIdFromDB(int id) returns model:SandwichInfo|error{ 
    model:SandwichInfo|error ing = check dbClient->queryRow( `SELECT * FROM sandwiches WHERE sandwich_id = ${id}`);
    return ing;
}

public isolated function findSandwichByIdsFromDB() returns int[]|error{
    model:SandwichInfo[] infos = [];
    int[] array = [];
    stream<model:SandwichInfo, sql:Error?> resultStream = dbClient->query(`SELECT * from sandwiches`);
    check from model:SandwichInfo info in resultStream
        do {
            infos.push(info);
        };
    check resultStream.close();
    foreach model:SandwichInfo n in infos {
        array.push(n.sandwich_id);
        
    }
    return array;
}

public isolated function findSandwichIngredientsByIdFromDB(int id) returns int[]|error{
    model:N[] array = [];
    int[] arrayInt = [];
    stream<model:N, sql:Error?> resultStream = dbClient->query(`SELECT ingredient_id FROM sandwich_ingredients WHERE sandwich_id  = ${id}`);
    check from model:N des in resultStream
        do {
            array.push(des);
        };
    check resultStream.close();
    foreach model:N n in array {
        arrayInt.push(n.ingredient_id);
    }
    return arrayInt;
}

public isolated function findSandwichDescriptionsByIdFromDB(int id) returns model:Description[]|error{
    model:Description[] descriptions = [];
    stream<model:Description, sql:Error?> resultStream = dbClient->query(`SELECT text, language FROM sandwich_descriptions where sandwich_id = ${id}`);
    check from model:Description des in resultStream
        do {
            descriptions.push(des);
        };
    check resultStream.close();
    return descriptions;
}

public isolated function hasDuplicates(int[] array) returns boolean{
    int[] arraySorted = array.sort();
    int found = -1;
    int aux = arraySorted[0];
    foreach int n in arraySorted{
        if aux == n{
            found +=1;
            aux = n;
        }
    }
    if found > 0{
        return true;
    }
    else{
        return false;
    }
}

