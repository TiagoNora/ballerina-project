import ballerina/http;
import orderService.model;
import orderService.serviceOrder;
service /orders on new http:Listener(8094) {

    isolated resource function post .(@http:Payload model:OrderDTO orderObject) returns error|model:ValidationError|model:OrderObject?|model:NotFoundError|int{
        return serviceOrder:addOrder(orderObject);
    }
    isolated resource function get searchById(int id) returns model:OrderObject?|error|model:NotFoundError {
        return serviceOrder:getOrderById(id);
    }
    isolated resource function get .() returns model:OrderObject[]|error?|model:NotFoundError {
        return serviceOrder:getAllOrders();
    }
    isolated resource function get searchByUserId(int id) returns model:OrderObject[]?|error|model:NotFoundError {
        return serviceOrder:getOrdersByUserId(id);
    }
    isolated resource function get searchByStoreId(int id) returns model:OrderObject[]?|error|model:NotFoundError {
        return serviceOrder:getOrdersByStoreId(id);
    }
    isolated resource function put admin(int id) returns model:OrderObject?|error|model:NotFoundError|model:ValidationError|int|model:Conflict {
        return serviceOrder:updateOrderById(id);
    }
    isolated resource function put .(int id) returns model:OrderObject?|error|model:NotFoundError|model:ValidationError|int|model:Conflict {
        return serviceOrder:updateUserOrderById(id);
    }
}