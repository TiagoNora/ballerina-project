import ballerina/http;
import store.model;
import store.serviceStore;
service /stores on new http:Listener(8093) {

    isolated resource function post .(@http:Payload model:StoreDTO ing) returns error|model:ValidationError|model:Store?|model:NotFoundError|int{
        return serviceStore:addStore(ing);
    }
    isolated resource function get .() returns model:Store[]|error?|model:NotFoundError {
        return serviceStore:getAllStores();
    }

    isolated resource function get searchById(int id) returns model:Store?|error|model:NotFoundError {
        return serviceStore:getStoreById(id);
    }

    isolated resource function get searchByDesignation(string designation) returns model:Store?|error|model:NotFoundError {
        return serviceStore:getStoreByDesignation(designation);
    }

    isolated resource function get searchByLocation(string location) returns model:Store?|error|model:NotFoundError {
        return serviceStore:getStoreByLocation(location);
    }

    isolated resource function delete delete(int id) returns model:Deleted|error|model:NotFoundError {
        return serviceStore:deleteStoreById(id);
    }

    isolated resource function put closingHours(@http:Payload model:ClosingHours hours, int id) returns model:Store?|error|model:NotFoundError {
        return serviceStore:updateClosingHoursById(hours, id);
    }

    isolated resource function put openingHours(@http:Payload model:OpeningHours hours, int id) returns model:Store?|error|model:NotFoundError {
        return serviceStore:updateOpeningHoursById(hours, id);
    }

}