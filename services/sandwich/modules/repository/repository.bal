import ballerinax/mysql;
import ballerinax/mysql.driver as _; 
import ballerina/sql;
import ballerina/http;
import sandwich.model;

string USER="myUser";
string PASSWORD="myPassword";
string HOST="localhost";
int PORT=3307;

final mysql:Client dbClient;
final http:Client language;

function init() returns error? {
    mysql:Client dbClientCreate = check new(host=HOST, user=USER, password=PASSWORD, port=PORT);
    sql:ExecutionResult _ = check dbClientCreate->execute(`CREATE DATABASE IF NOT EXISTS Sandwiches`);
    check dbClientCreate.close();
    language = check new (url = "http://localhost:5000");
    dbClient = check new(host=HOST, user=USER, password=PASSWORD, port=PORT, database="Sandwiches"); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Sandwiches.sandwiches (
                                                    sandwich_id INT NOT NULL AUTO_INCREMENT, 
                                                    selling_price FLOAT(6), 
                                                    designation VARCHAR(30), 
                                                    PRIMARY KEY (sandwich_id)
                                                    )`); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Sandwiches.sandwich_ingredients (
                                                    sandwich_id INT NOT NULL, 
                                                    ingredient_id INT NOT NULL, 
                                                    PRIMARY KEY (sandwich_id, ingredient_id), 
                                                    FOREIGN KEY (sandwich_id) REFERENCES sandwiches(sandwich_id)
                                                    )`);
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Sandwiches.sandwich_descriptions (
                                                    sandwich_id INT NOT NULL, 
                                                    text VARCHAR(500), 
                                                    language VARCHAR(5), 
                                                    PRIMARY KEY (sandwich_id, language), 
                                                    FOREIGN KEY (sandwich_id) REFERENCES sandwiches(sandwich_id)
                                                    )`);                                    
}

public isolated function addSandwich(model:SandwichDTO san) returns model:ServiceError|model:Sandwich|error|model:NotFoundError|model:ValidationError|model:NotFoundError{
    if san.ingredients_id.length() < 3{
        return validationError("SANDWICH_WITH_NO_INGREDIENTS","The sandwich that has received contains no ingredients");
    }
    else {
        if hasDuplicates(san.ingredients_id) == true{
            return validationError("INGREDIENTS_DUPLICATED","One of the ingredients insert into the list is duplicated");
        }
        foreach int n in san.ingredients_id {
            boolean|error flag = findIngredientByIdFromRest(n);
            if flag == false{
                return notFound("INGREDIENT_NOT_FOUND","One of the ingredients insert into the list doesn´t exists");
            }
        }
    }
    if san.descriptions.length() == 0{
        return validationError("SANDWICH_WITH_NO_DESCRIPTIONS","The sandwich that has been received contains no descriptions");
    }
    json a = san.descriptions.toJson();
    json|error postResponse = language->post(path = "/language", message = a);
    if postResponse is error{
        return serviceError("SERVICE_ERROR","SERVICE ERROR");
    }
    json|error received = postResponse.languages;
    if received is error{
        return notFound("LANGUAGE_NOT_FOUND","The language inserted into the list doesn´t exists");
    }
    json[] c  = check postResponse.languages.ensureType();
    string[] languages = [];
    foreach var item in c{
        languages.push(item.toString());
    }
    model:Description[] descriptions = [];
    int i = 0;
    foreach model:DescriptionDTO item in san.descriptions {
        model:Description d = {
            "text": item.text,
            "language" : languages[i]
        };
        descriptions.push(d);
        i += 1;
    }

    int|model:NotFoundError|error lastIdInserted = addSandwichToDB(san.selling_price,san.designation);
    int n = 0;
    if lastIdInserted is int{
        n = lastIdInserted;
    }
    foreach int ingrediend_id in san.ingredients_id {
        sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO sandwich_ingredients (sandwich_id, ingredient_id) VALUES (${n}, ${ingrediend_id})`);
    }
    foreach model:Description description in descriptions {
        sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO sandwich_descriptions (sandwich_id , text, language) VALUES (${n}, ${description.text}, ${description.language})`);
    }

    model:Sandwich|error|model:NotFoundError sand = getSandwichById(n);

    return sand;
}

public isolated function getSandwichById(int id) returns model:Sandwich|error|model:NotFoundError{
    model:SandwichInfo|error info = findSandwichByIdFromDB(id);
    if info is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded");
    } 
    int[]|error array = findSandwichIngredientsByIdFromDB(id);
    if array is error{
        return notFound("QUERY_ERROR","To the given id no ingredients were found");
    }
    model:Description[]|error descriptions = findSandwichDescriptionsByIdFromDB(id);
    if descriptions is error{
        return notFound("QUERY_ERROR","To the given id no descritpions were found");
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
        return notFound("SANDWICHES_NOT_FOUND","No sandwiches were found");
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
        return notFound("SANDWICH_ID_NOT_FOUND","The searched sandwich has not founded");
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

public isolated function addIngredients(model:Ns ns, int id) returns model:Sandwich|error|model:NotFoundError|error|model:ValidationError|model:NotFoundError{

    boolean flag = checkSandwichId(id);
    if flag == false{
        return notFound("SANDWICH_ID_NOT_FOUND","The searched sandwich has not founded");
    }
    int[]|error found = findSandwichIngredientsByIdFromDB(id);
    if found is error{
        return notFound("QUERY_ERROR","To the given id no ingredients were found");
    }
    int[] array = ns.ingredients_id;
    boolean aux = checkArrayReceivedAndFound(array,found);
    if aux == false{
        return validationError("INGREDIENTS_DUPLICATED","The ingredients received were duplicated");
    }
    foreach int n in array {
        boolean|error b = findIngredientByIdFromRest(n);
        if b == false{
            return notFound("INGREDIENT_NOT_FOUND","One of the ingredients insert into the list doesn´t exists");
        }
    }
    foreach int n in array {
        sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO sandwich_ingredients (sandwich_id, ingredient_id) VALUES (${id}, ${n})`);
        
    }
    model:Sandwich|error|model:NotFoundError sand = getSandwichById(id);

    return sand;

}

public isolated function checkSandwichId(int id) returns boolean{
    model:SandwichInfo|error sand= findSandwichByIdFromDB(id);
    if sand is model:SandwichInfo{
        return true;
    }
    else {
        return false;
    }
}

public isolated function checkArrayReceivedAndFound (int[] received, int[] found) returns boolean{
    int aux = 0;
    foreach int nFound in found{
        foreach int nReceived in received {
            if nFound == nReceived{
                aux += 1;
            }
        }
    }
    
    if aux == 0{
        return true;
    }
    else {
        return false;
    }
}

public isolated function addDescriptions(model:DescriptionsDTO des, int id) returns model:ServiceError|model:Sandwich|error|model:NotFoundError|error|model:ValidationError|model:NotFoundError{
    boolean flag = checkSandwichId(id);
    if flag == false{
        return notFound("SANDWICH_ID_NOT_FOUND","The searched sandwich has not founded");
    }
    model:Description[]|error found = findSandwichDescriptionsByIdFromDB(id);
    if found is error{
        return notFound("QUERY_ERROR","To the given id no descriptions were found");
    }
    json a = des.descriptions.toJson();
    json|error postResponse = language->post(path = "/language", message = a);
    if postResponse is error{
        return serviceError("SERVICE_ERROR","SERVICE ERROR");
    }
    json|error received = postResponse.languages;
    if received is error{
        return notFound("LANGUAGE_NOT_FOUND","The language inserted into the list doesn´t exists");
    }
    json[] c  = check postResponse.languages.ensureType();
    string[] languages = [];
    foreach var item in c{
        languages.push(item.toString());
    }
    model:Description[] descriptions = [];
    int i = 0;
    foreach model:DescriptionDTO item in des.descriptions {
        model:Description d = {
            "text": item.text,
            "language" : languages[i]
        };
        descriptions.push(d);

        i += 1;
    }
    model:Descriptions desc = {
        descriptions:descriptions
    };
    boolean aux = checkDescriptionsDuplicated(found,desc);
    if aux == false{
        return validationError("DESCRIPTIONS_DUPLICATED","The description received were duplicated");
    }
    foreach model:Description de in descriptions {
        sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO sandwich_descriptions (sandwich_id , text, language) VALUES (${id}, ${de.text}, ${de.language})`);
    }

    model:Sandwich|error|model:NotFoundError sand = getSandwichById(id);

    return sand;
}


public isolated function checkDescriptionsDuplicated (model:Description[] found, model:Descriptions des) returns boolean{
    int aux = 0;
    foreach model:Description nFound in found{
        foreach model:Description nReceived in des.descriptions {
            if nFound.language == nReceived.language{
                aux += 1;
            }
        }
    }
    
    if aux == 0{
        return true;
    }
    else {
        return false;
    }
}

public isolated function getWithoutId(int id) returns model:Sandwich[]|model:NotFoundError{
    model:Sandwich[] sandwiches = [];
    boolean|error b = findIngredientByIdFromRest(id);
    if b == false{
        return notFound("INGREDIENT_NOT_FOUND","The ingredient doesn´t exist");
    }

    int[]|error array = getSandwichesWithoutIngredientId(id);
    if array is error{
        return notFound("INGREDIENT_NOT_FOUND","The ingredient doesn´t exist");
    }

    foreach int n in array{
        model:Sandwich|error|model:NotFoundError sand = getSandwichById(n);
        if sand is model:Sandwich{
            sandwiches.push(sand);
        }
    }

    return sandwiches;
}


public isolated function getSandwichesWithoutIngredientId(int id) returns int[]|error{
    model:NQuery[] array = [];
    int[] arrayInt = [];
    stream<model:NQuery, sql:Error?> resultStream = dbClient->query(`SELECT DISTINCT sandwich_id FROM sandwich_ingredients A WHERE sandwich_id not in (select sandwich_id from sandwich_ingredients B where ingredient_id = ${id} and B.sandwich_id = A.sandwich_id)`);
    check from model:NQuery des in resultStream
        do {
            array.push(des);
        };
    check resultStream.close();
    foreach model:NQuery n in array {
        arrayInt.push(n.sandwich_id);
    }
    return arrayInt;
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

public isolated function serviceError(string codeMessage,string messageError) returns model:ServiceError{
    return <model:ServiceError>{
            body: {
                'error: {
                    code: codeMessage,
                    message: messageError
                }
            }
               
    };
}
