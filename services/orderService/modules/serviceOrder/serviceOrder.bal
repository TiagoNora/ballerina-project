import orderService.model;
import orderService.repository;

public isolated function addOrder(model:OrderDTO orderObject) returns model:OrderObject?|error|model:NotFoundError|model:ValidationError|int{
    error|int n = repository:addOrder(orderObject);
    if n is int{
        model:OrderObject|error|model:NotFoundError or = repository:getOrderById(n);
        return or;
    }
}

public isolated function getOrderById(int id) returns model:OrderObject|error|model:NotFoundError{
    model:OrderInfo|error info = repository:findOrderByIdFromDB(id);
    if info is error{
           return notFound("ORDER_NOT_FOUND","The searched sandwich has not founded");
    } 
    model:OrderItem[]|error array = repository:findOrderItemsByIdFromDB(id);
    if array is error{
        return notFound("QUERY_ERROR","To the given id no ingredients were found");
    }
    
    model:OrderObject orderO = {
        order_id: id,
        store_id: info.store_id,
        user_id: info.user_id,
        status: info.status,
        dateOfCreation: info.dateOfCreation,
        items: array
    };
    return orderO;

}

public isolated function getAllOrders() returns model:OrderObject[]|error?|model:NotFoundError {
    model:OrderObject[]|error?|model:NotFoundError ors = repository:getAllOrders();
    if ors is model:OrderObject[]{
        return ors;
    }
}

public isolated function getOrdersByUserId(int id) returns model:OrderObject[]|error|model:NotFoundError{
    model:OrderObject[] orders = [];
    int[]|error array = repository:findOrdersByUserFromDB(id);
    if array is error{
        return notFound("ORDERS_NOT_FOUND","No orders were found");
    }
    foreach int n in array {
        model:OrderObject?|error|model:NotFoundError sand = repository:getOrderById(n);
        orders.push(<model:OrderObject>check sand);
    }
    return orders;

}

public isolated function getOrdersByStoreId(int id) returns model:OrderObject[]|error|model:NotFoundError{
    model:OrderObject[] orders = [];
    int[]|error array = repository:findOrdersByStoreFromDB(id);
    if array is error{
        return notFound("ORDERS_NOT_FOUND","No orders were found");
    }
    foreach int n in array {
        model:OrderObject?|error|model:NotFoundError sand = repository:getOrderById(n);
        orders.push(<model:OrderObject>check sand);
    }
    return orders;

}

public isolated function updateOrderById(int id) returns model:OrderObject?|error|model:NotFoundError|model:ValidationError|int|model:Conflict{
    model:OrderInfo|error info = repository:findOrderByIdFromDB(id);
    if info is error{
           return notFound("ORDER_NOT_FOUND","The searched sandwich has not founded");
    }
    else{
        if info.status == "PENDING"{
            string newStatus = "PROCESSING";
            _ = check repository:updateOrderById(newStatus,id);
        }
        else if info.status == "PROCESSING" {
            string newStatus = "DONE";
            _ = check repository:updateOrderById(newStatus,id);
        }
        else if info.status == "DONE"{
            string newStatus = "DELIVERED";
            _ = check repository:updateOrderById(newStatus,id);
        }
        else {
            return conflictError("ORDER_ALREADY_DELIVERED","The order was already delivered to the client");
        }
    }
    model:OrderObject|error|model:NotFoundError or = getOrderById(id);
    return or;

}

public isolated function updateUserOrderById(int id) returns model:OrderObject?|error|model:NotFoundError|model:ValidationError|int|model:Conflict{
    model:OrderInfo|error info = repository:findOrderByIdFromDB(id);
    if info is error{
           return notFound("ORDER_NOT_FOUND","The searched sandwich has not founded");
    }
    else{
        if info.status == "PENDING"{
            string newStatus = "CANCELED";
            _ = check repository:updateUserOrderById(newStatus,id);
        }
        else {
            return conflictError("ORDER_ATIVE","The order is been made, has made or has delivered");
        }
    }
    model:OrderObject|error|model:NotFoundError or = getOrderById(id);
    return or;

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

public isolated function conflictError(string codeMessage,string messageError) returns model:Conflict{
    return <model:Conflict>{
            body: {
                'error: {
                    code: codeMessage,
                    message: messageError
                }
            }
               
    };
}
