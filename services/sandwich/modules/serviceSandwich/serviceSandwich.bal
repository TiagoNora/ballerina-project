import sandwich.model;
import sandwich.repository;
import ballerina/http;

final http:Client language;
function init() returns error? {
    language = check new (url = "http://localhost:5000");
                                   
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
            boolean|error flag = repository:findIngredientByIdFromRest(n);
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

    int|model:NotFoundError|error lastIdInserted = repository:addSandwichToDB(san.selling_price,san.designation);
    int n = 0;
    if lastIdInserted is int{
        n = lastIdInserted;
    }
    foreach int ingrediend_id in san.ingredients_id {
        _ = check repository:addSandwichIngredient(n,ingrediend_id);
    }
    foreach model:Description description in descriptions {
        _ = check repository:addSandwichDescription(n,description.text,description.language);
    }

    model:Sandwich|error|model:NotFoundError sand = repository:getSandwichById(n);
    if sand is model:Sandwich{
        _ = check repository:addRabbit(sand);
    }

    return sand;
}

public isolated function getSandwichById(int id) returns model:Sandwich|error|model:NotFoundError{
    model:SandwichInfo|error info = repository:findSandwichByIdFromDB(id);
    if info is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded");
    } 
    int[]|error array = repository:findSandwichIngredientsByIdFromDB(id);
    if array is error{
        return notFound("QUERY_ERROR","To the given id no ingredients were found");
    }
    model:Description[]|error descriptions = repository:findSandwichDescriptionsByIdFromDB(id);
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
    int[]|error array = repository:findSandwichByIdsFromDB();
    if array is error{
        return notFound("SANDWICHES_NOT_FOUND","No sandwiches were found");
    }
    foreach int n in array {
        model:Sandwich?|error|model:NotFoundError sand = repository:getSandwichById(n);
        sandwiches.push(<model:Sandwich>check sand);
    }
    return sandwiches;
}

public isolated function addIngredients(model:Ns ns, int id) returns model:Sandwich|error|model:NotFoundError|error|model:ValidationError|model:NotFoundError{

    boolean flag = repository:checkSandwichId(id);
    if flag == false{
        return notFound("SANDWICH_ID_NOT_FOUND","The searched sandwich has not founded");
    }
    int[]|error found = repository:findSandwichIngredientsByIdFromDB(id);
    if found is error{
        return notFound("QUERY_ERROR","To the given id no ingredients were found");
    }
    int[] array = ns.ingredients_id;
    boolean aux = repository:checkArrayReceivedAndFound(array,found);
    if aux == false{
        return validationError("INGREDIENTS_DUPLICATED","The ingredients received were duplicated");
    }
    foreach int n in array {
        boolean|error b = repository:findIngredientByIdFromRest(n);
        if b == false{
            return notFound("INGREDIENT_NOT_FOUND","One of the ingredients insert into the list doesn´t exists");
        }
    }
    foreach int n in array {
        _ = check repository:addSandwichIngredient(id,n);
        
    }
    model:Sandwich|error|model:NotFoundError sand = repository:getSandwichById(id);

    return sand;

}

public isolated function addDescriptions(model:DescriptionsDTO des, int id) returns model:ServiceError|model:Sandwich|error|model:NotFoundError|error|model:ValidationError|model:NotFoundError{
    boolean flag = repository:checkSandwichId(id);
    if flag == false{
        return notFound("SANDWICH_ID_NOT_FOUND","The searched sandwich has not founded");
    }
    model:Description[]|error found = repository:findSandwichDescriptionsByIdFromDB(id);
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
    boolean aux = repository:checkDescriptionsDuplicated(found,desc);
    if aux == false{
        return validationError("DESCRIPTIONS_DUPLICATED","The description received were duplicated");
    }
    foreach model:Description de in descriptions {
        _ = check repository:addSandwichDescription(id,de.text,de.language);
    }

    model:Sandwich|error|model:NotFoundError sand = getSandwichById(id);

    return sand;
}


public isolated function getWithoutId(int id) returns model:Sandwich[]|model:NotFoundError{
    model:Sandwich[] sandwiches = [];
    boolean|error b = repository:findIngredientByIdFromRest(id);
    if b == false{
        return notFound("INGREDIENT_NOT_FOUND","The ingredient doesn´t exist");
    }

    int[]|error array = repository:getSandwichesWithoutIngredientId(id);
    if array is error{
        return notFound("INGREDIENT_NOT_FOUND","The ingredient doesn´t exist");
    }

    foreach int n in array{
        model:Sandwich|error|model:NotFoundError sand = repository:getSandwichById(n);
        if sand is model:Sandwich{
            sandwiches.push(sand);
        }
    }

    return sandwiches;
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
