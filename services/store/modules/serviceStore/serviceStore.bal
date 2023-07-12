import store.model;
import store.repository;
import ballerina/time;
public isolated function addStore(model:StoreDTO store) returns model:Store?|error|model:NotFoundError|model:ValidationError|int{
    int|model:NotFoundError|error lastIdInserted = repository:addStoreToDB(store.designation,time:utcNow());
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
    _ = check repository:addAddressToDB(a,n);

    foreach model:ClosingHours closing in store.closingHours {
         _ = check repository:addClosingHoursToDB(n,closing);
    }
    foreach model:OpeningHours opening in store.openingHours {
         _ = check repository:addOpeningHoursToDB(n,opening);
    }
    _ = check repository:addRabbit(store);
    model:Store|error|model:NotFoundError s = getStoreById(n);
    return s;

}

public isolated function getAllStores() returns model:Store[]|error?|model:NotFoundError {
    model:Store[] stores = [];
    int[]|error array = repository:findStoresByIdsFromDB();
    if array is error{
        return notFound("SANDWICHES_NOT_FOUND","No sandwiches were found");
    }
    foreach int n in array {
        model:Store?|error|model:NotFoundError sand = repository:getStoreById(n);
        stores.push(<model:Store>check sand);
    }
    return stores;
}

public isolated function getStoreById(int id) returns model:Store|error|model:NotFoundError{
    model:StoreAux|error aux = repository:findStoreByIdFromDB(id);
    if aux is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded1");
    } 
    model:Address|error add = repository:findAddressByIdFromDB(id);
    if add is error{
        return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded2");
    } 
    model:ClosingHours[]|error closing = repository:findClosingHoursByIdFromDB(id);
    if closing is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded3");
    } 
    model:OpeningHours[]|error opening = repository:findOpeningHoursByIdFromDB(id);
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

public isolated function getStoreByDesignation(string designation) returns model:Store|error|model:NotFoundError{
    model:StoreAux|error aux = repository:findStoreByDesignationFromDB(designation);
    if aux is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded1");
    } 
    model:Address|error add = repository:findAddressByIdFromDB(aux.store_id);
    if add is error{
        return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded2");
    } 
    model:ClosingHours[]|error closing = repository:findClosingHoursByIdFromDB(aux.store_id);
    if closing is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded3");
    } 
    model:OpeningHours[]|error opening = repository:findOpeningHoursByIdFromDB(aux.store_id);
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
    model:AddressAux|error add = repository:findAddressByLocationFromDB(location);
    if add is error{
        return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded2");
    } 
    model:StoreAux|error aux = repository:findStoreByIdFromDB(add.store_id);
    if aux is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded1");
    } 
    model:Address|error add1 = repository:findAddressByIdFromDB(add.store_id);
    if add1 is error{
        return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded2");
    } 
    model:ClosingHours[]|error closing = repository:findClosingHoursByIdFromDB(add.store_id);
    if closing is error{
           return notFound("SANDWICH_NOT_FOUND","The searched sandwich has not founded3");
    } 
    model:OpeningHours[]|error opening = repository:findOpeningHoursByIdFromDB(add.store_id);
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

public isolated function deleteStoreById(int id) returns model:Deleted|error|model:NotFoundError{
    _ = check repository:deleteStoreById(id);
    return deleted("DELETED","The store was deleted with success!");
}

public isolated function updateClosingHoursById(model:ClosingHours hours, int id) returns model:Store?|error|model:NotFoundError {
    _ = check repository:updateClosingHoursById(hours,id);
    model:Store|error|model:NotFoundError s = repository:getStoreById(id);
    return s;
}

public isolated function updateOpeningHoursById(model:OpeningHours hours, int id) returns model:Store?|error|model:NotFoundError {
    _ = check repository:updateOpeningHoursById(hours,id);
    model:Store|error|model:NotFoundError s = repository:getStoreById(id);
    return s;
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