import ballerinax/mysql;
import ballerinax/mysql.driver as _; 
import ballerina/sql;
import store.model;
import ballerina/time;
import ballerina/io;

string USER = "myUser";
string PASSWORD = "myPassword";
string HOST = "localhost";
int PORT = 3309;

final mysql:Client dbClient;

function init() returns error? {
    mysql:Client dbClientCreate = check new(host=HOST, user=USER, password=PASSWORD, port=PORT);
    sql:ExecutionResult _ = check dbClientCreate->execute(`CREATE DATABASE IF NOT EXISTS Stores`);
    check dbClientCreate.close();

    dbClient = check new(host=HOST, user=USER, password=PASSWORD, port=PORT, database="Stores"); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Stores.stores (
                                                    store_id INT NOT NULL AUTO_INCREMENT, 
                                                    designation VARCHAR(255),
                                                    dateOfCreation VARCHAR(255),
                                                    PRIMARY KEY (store_id,designation))`); 

    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Stores.stores_address (
                                                    address_id INT NOT NULL AUTO_INCREMENT,
                                                    store_id INT NOT NULL,
                                                    zipCode VARCHAR(255),
                                                    streetName VARCHAR(255), 
                                                    doorNumber INT, 
                                                    location VARCHAR(255), 
                                                    country VARCHAR(255), 
                                                    PRIMARY KEY (address_id), 
                                                    FOREIGN KEY (store_id) REFERENCES stores(store_id))`);

    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Stores.closingHours (
                                                    closingHours_id INT NOT NULL AUTO_INCREMENT,
                                                    store_id INT NOT NULL,
                                                    dayOfTheWeek VARCHAR(255),
                                                    hour INT, 
                                                    minute INT, 
                                                    PRIMARY KEY (closingHours_id), 
                                                    FOREIGN KEY (store_id) REFERENCES stores(store_id))`); 

    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Stores.openingHours (
                                                    openingHours_id INT NOT NULL AUTO_INCREMENT,
                                                    store_id INT NOT NULL,
                                                    dayOfTheWeek VARCHAR(255),
                                                    hour INT, 
                                                    minute INT, 
                                                    PRIMARY KEY (openingHours_id), 
                                                    FOREIGN KEY (store_id) REFERENCES stores(store_id))`);                             
}

public isolated function addStore(model:StoreDTO store) returns model:Store?|error|model:NotFoundError|model:ValidationError|int{
    int|model:NotFoundError|error lastIdInserted = addStoreToDB(store.designation,time:utcNow());
    int n = 0;
    if lastIdInserted is int{
        n = lastIdInserted;
    }
    model:Address a ={
        "zipCode":store.address.zipCode,
        "streetName":store.address.streetName,
        "doorNumber":store.address.doorNumber,
        "location":store.address.location,
        "country":store.address.country
    };
    _ = check addAddressToDB(a,n);

    foreach model:ClosingHours closing in store.closingHours {
         _ = check addClosingHoursToDB(n,closing);
    }
    foreach model:OpeningHours opening in store.openingHours {
         _ = check addOpeningHoursToDB(n,opening);
    }

    model:Store|error|model:NotFoundError s = getStoreById(n);
    return s;

}

public isolated function getStoreById(int id) returns model:Store|error|model:NotFoundError{
    model:StoreAux|error aux = findStoreByIdFromDB(id);
    if aux is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded1");
    } 
    model:Address|error add = findAddressByIdFromDB(id);
    if add is error{
        io:print(add);
        return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded2");
    } 
    model:ClosingHours[]|error closing = findClosingHoursByIdFromDB(id);
    if closing is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded3");
    } 
    model:OpeningHours[]|error opening = findOpeningHoursByIdFromDB(id);
    if opening is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded4");
    } 
    model:Store store = {
        "store_id": id,
        "designation": aux.designation,
        "dateOfCreation" : aux.dateOfCreation,
        "closingHours" : closing,
        "openingHours" : opening,
        "address": add
    };
    return store;
}

public isolated function deleteStoreById(int id) returns model:Deleted|error|model:NotFoundError{
    _ = check dbClient->execute(`DELETE from openingHours WHERE store_id = ${id}`);
    _ = check dbClient->execute(`DELETE from closingHours WHERE store_id = ${id}`);
    _ = check dbClient->execute(`DELETE from stores_address WHERE store_id = ${id}`);
    _ = check dbClient->execute(`DELETE from stores WHERE store_id = ${id}`);
    return deleted("DELETED","The store was deleted with success!");
}
public isolated function updateClosingHoursById(model:ClosingHours hours, int id) returns model:Store?|error|model:NotFoundError {
    _ = check dbClient->execute(`UPDATE closingHours SET hour=${hours.hour} , minute=${hours.minute} WHERE store_id = ${id} and dayOfTheWeek = ${hours.dayOfTheWeek}`);
    model:Store|error|model:NotFoundError s = getStoreById(id);
    return s;
}

public isolated function updateOpeningHoursById(model:OpeningHours hours, int id) returns model:Store?|error|model:NotFoundError {
    _ = check dbClient->execute(`UPDATE openingHours SET hour=${hours.hour} , minute=${hours.minute} WHERE store_id = ${id} and dayOfTheWeek = ${hours.dayOfTheWeek}`);
    model:Store|error|model:NotFoundError s = getStoreById(id);
    return s;
}

public isolated function getStoreByDesignation(string designation) returns model:Store|error|model:NotFoundError{
    model:StoreAux|error aux = findStoreByDesignationFromDB(designation);
    io:print(aux);
    if aux is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded1");
    } 
    model:Address|error add = findAddressByIdFromDB(aux.store_id);
    if add is error{
        io:print(add);
        return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded2");
    } 
    model:ClosingHours[]|error closing = findClosingHoursByIdFromDB(aux.store_id);
    if closing is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded3");
    } 
    model:OpeningHours[]|error opening = findOpeningHoursByIdFromDB(aux.store_id);
    if opening is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded4");
    } 
    model:Store store = {
        "store_id": aux.store_id,
        "designation": aux.designation,
        "dateOfCreation" : aux.dateOfCreation,
        "closingHours" : closing,
        "openingHours" : opening,
        "address": add
    };
    return store;
}

public isolated function getStoreByLocation(string location) returns model:Store|error|model:NotFoundError{
    model:AddressAux|error add = findAddressByLocationFromDB(location);
    if add is error{
        io:print(add);
        return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded2");
    } 
    model:StoreAux|error aux = findStoreByIdFromDB(add.store_id);
    io:print(aux);
    if aux is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded1");
    } 
    model:Address|error add1 = findAddressByIdFromDB(add.store_id);
    if add1 is error{
        io:print(add);
        return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded2");
    } 
    model:ClosingHours[]|error closing = findClosingHoursByIdFromDB(add.store_id);
    if closing is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded3");
    } 
    model:OpeningHours[]|error opening = findOpeningHoursByIdFromDB(add.store_id);
    if opening is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded4");
    } 
    model:Store store = {
        "store_id": add.store_id,
        "designation": aux.designation,
        "dateOfCreation" : aux.dateOfCreation,
        "closingHours" : closing,
        "openingHours" : opening,
        "address": add
    };
    return store;
}

public isolated function getAllStores() returns model:Store[]|error?|model:NotFoundError {
    model:Store[] stores = [];
    int[]|error array = findStoresByIdsFromDB();
    if array is error{
        return notFound("SANDWICHES_NOT_FOUND","No sandwiches were found");
    }
    foreach int n in array {
        model:Store?|error|model:NotFoundError sand = getStoreById(n);
        stores.push(<model:Store>check sand);
    }
    return stores;
}

public isolated function findStoresByIdsFromDB() returns int[]|error{
    model:StoreAux[] infos = [];
    int[] array = [];
    stream<model:StoreAux, sql:Error?> resultStream = dbClient->query(`SELECT * from stores`);
    check from model:StoreAux info in resultStream
        do {
            infos.push(info);
        };
    check resultStream.close();
    foreach model:StoreAux n in infos {
        array.push(n.store_id);
        
    }
    return array;
}

public isolated function findStoreByIdFromDB(int id) returns model:StoreAux|error{ 
    model:StoreAux|error store = check dbClient->queryRow( `SELECT * FROM stores WHERE store_id = ${id}`);
    return store;
}

public isolated function findStoreByDesignationFromDB(string designation) returns model:StoreAux|error{ 
    model:StoreAux|error store = check dbClient->queryRow( `SELECT * FROM stores WHERE designation = ${designation}`);
    return store;
}

public isolated function findAddressByIdFromDB(int id) returns model:Address|error{ 
    model:Address|error address = check dbClient->queryRow( `SELECT zipCode, streetName, doorNumber, location, country FROM stores_address WHERE store_id = ${id}`);
    return address;
}

public isolated function findAddressByLocationFromDB(string location) returns model:AddressAux|error{ 
    model:AddressAux|error address = check dbClient->queryRow( `SELECT store_id, zipCode, streetName, doorNumber, location, country FROM stores_address WHERE location = ${location}`);
    return address;
}

//public isolated function findAddressByIdFromDB(int id) returns model:Address[]|error{
//    model:Address[] add = [];
//    stream<model:Address, sql:Error?> resultStream = dbClient->query(`SELECT dayOfTheWeek, hour, minute  FROM closingHours where store_id = ${id}`);
//    check from model:Address des in resultStream
//        do {
//            add.push(des);
 //       };
//   check resultStream.close();
 //   return add;
//}


public isolated function findClosingHoursByIdFromDB(int id) returns model:ClosingHours[]|error{
    model:ClosingHours[] closingHours = [];
    stream<model:ClosingHours, sql:Error?> resultStream = dbClient->query(`SELECT dayOfTheWeek, hour, minute  FROM closingHours where store_id = ${id}`);
    check from model:ClosingHours des in resultStream
        do {
            closingHours.push(des);
        };
    check resultStream.close();
    return closingHours;
}

public isolated function findOpeningHoursByIdFromDB(int id) returns model:OpeningHours[]|error{
    model:OpeningHours[] openingHours = [];
    stream<model:OpeningHours, sql:Error?> resultStream = dbClient->query(`SELECT dayOfTheWeek, hour, minute  FROM openingHours where store_id = ${id}`);
    check from model:OpeningHours des in resultStream
        do {
            openingHours.push(des);
        };
    check resultStream.close();
    return openingHours;
}


public isolated function addStoreToDB(string designation, time:Utc dateOfCreation) returns int|model:NotFoundError|error{
    sql:ExecutionResult result = check dbClient->execute(`INSERT INTO stores (designation, dateOfCreation) VALUES (${designation}, ${dateOfCreation})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int{
        return lastInsertId;
    }
    else {
        return notFound("STORE_ID_NOT_FOUND","The searched store was not founded");
    }

}

public isolated function addAddressToDB(model:Address a, int n) returns int|model:NotFoundError|error{
    sql:ExecutionResult result = check dbClient->execute(`INSERT INTO stores_address (store_id, zipCode, streetName, doorNumber, location, country) VALUES 
    (${n}, ${a.zipCode},${a.streetName},${a.doorNumber},${a.location},${a.country})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int{
        return lastInsertId;
    }
    else {
        return notFound("ADDRESS_ID_NOT_FOUND","The searched address was not founded");
    }

}

public isolated function addClosingHoursToDB(int n, model:ClosingHours closing) returns int|model:NotFoundError|error{
    sql:ExecutionResult result = check dbClient->execute(`INSERT INTO closingHours (store_id, dayOfTheWeek, hour, minute) VALUES (${n}, ${closing.dayOfTheWeek},${closing.hour},${closing.minute})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int{
        return lastInsertId;
    }
    else {
        return notFound("STORE_ID_NOT_FOUND","The searched store was not founded");
    }

}

public isolated function addOpeningHoursToDB(int n, model:OpeningHours opening) returns int|model:NotFoundError|error{
    sql:ExecutionResult result = check dbClient->execute(`INSERT INTO openingHours (store_id, dayOfTheWeek, hour, minute) VALUES (${n}, ${opening.dayOfTheWeek},${opening.hour},${opening.minute})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int{
        return lastInsertId;
    }
    else {
        return notFound("STORE_ID_NOT_FOUND","The searched store was not founded");
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

public isolated function deleted(string codeMessage,string messageError) returns model:Deleted{
    return <model:Deleted>{
            body: {
                'error: {
                    code: codeMessage,
                    message: messageError
                }
            }
               
    };
}