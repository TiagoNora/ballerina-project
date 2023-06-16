import ballerina/http;
import store.model;
import store.repository;
service /stores on new http:Listener(8093) {

    isolated resource function post .(@http:Payload model:StoreDTO ing) returns error|model:ValidationError|model:Store?|model:NotFoundError|int{
        return repository:addStore(ing);
    }
    isolated resource function get .() returns model:Store[]|error?|model:NotFoundError {
        return repository:getAllStores();
    }

    isolated resource function get searchById(int id) returns model:Store?|error|model:NotFoundError {
        return repository:getStoreById(id);
    }

    isolated resource function get searchByDesignation(string designation) returns model:Store?|error|model:NotFoundError {
        return repository:getStoreByDesignation(designation);
    }

    isolated resource function get searchByLocation(string location) returns model:Store?|error|model:NotFoundError {
        return repository:getStoreByLocation(location);
    }

    isolated resource function delete delete(int id) returns model:Deleted|error|model:NotFoundError {
        return repository:deleteStoreById(id);
    }

    isolated resource function put closingHours(@http:Payload model:ClosingHours hours, int id) returns model:Store?|error|model:NotFoundError {
        return repository:updateClosingHoursById(hours, id);
    }

    isolated resource function put openingHours(@http:Payload model:OpeningHours hours, int id) returns model:Store?|error|model:NotFoundError {
        return repository:updateOpeningHoursById(hours, id);
    }

}