import ballerina/http;
import orderService.model;
import orderService.repository;
service /orders on new http:Listener(8094) {

    isolated resource function post .(@http:Payload model:OrderDTO orderObject) returns error|model:ValidationError|model:OrderObject?|model:NotFoundError|int{
        return repository:addOrder(orderObject);
    }
    isolated resource function get searchById(int id) returns model:OrderObject?|error|model:NotFoundError {
        return repository:getOrderById(id);
    }
    isolated resource function get .() returns model:OrderObject[]|error?|model:NotFoundError {
        return repository:getAllOrders();
    }
    isolated resource function get searchByUserId(int id) returns model:OrderObject[]?|error|model:NotFoundError {
        return repository:getOrdersByUserId(id);
    }
    isolated resource function get searchByStoreId(int id) returns model:OrderObject[]?|error|model:NotFoundError {
        return repository:getOrdersByStoreId(id);
    }
    isolated resource function put admin(int id) returns model:OrderObject?|error|model:NotFoundError|model:ValidationError|int|model:Conflict {
        return repository:updateOrderById(id);
    }
    isolated resource function put .(int id) returns model:OrderObject?|error|model:NotFoundError|model:ValidationError|int|model:Conflict {
        return repository:updateUserOrderById(id);
    }
}