import ballerinax/mysql;
import ballerinax/mysql.driver as _; 
import ballerina/sql;
import orderService.model;
import ballerina/time;
import ballerina/io;

string USER = "myUser";
string PASSWORD = "myPassword";
string HOST = "localhost";
int PORT = 3310;

final mysql:Client dbClient;

function init() returns error? {
    mysql:Client dbClientCreate = check new(host=HOST, user=USER, password=PASSWORD, port=PORT);
    sql:ExecutionResult _ = check dbClientCreate->execute(`CREATE DATABASE IF NOT EXISTS Orders`);
    check dbClientCreate.close();

    dbClient = check new(host=HOST, user=USER, password=PASSWORD, port=PORT, database="Orders"); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Orders.orders (
                                                    order_id INT NOT NULL AUTO_INCREMENT, 
                                                    store_id INT NOT NULL,
                                                    user_id INT NOT NULL,
                                                    status VARCHAR(255),
                                                    dateOfCreation VARCHAR(255),
                                                    PRIMARY KEY (order_id))`); 

    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Orders.orders_items (
                                                    orderItem_id INT NOT NULL AUTO_INCREMENT,
                                                    order_id INT NOT NULL,
                                                    sandwich_id INT NOT NULL,
                                                    quantity INT NOT NULL, 
                                                    PRIMARY KEY (orderItem_id), 
                                                    FOREIGN KEY (order_id) REFERENCES orders(order_id))`);
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Orders.sandwiches (
                                                    sandwich_id INT NOT NULL AUTO_INCREMENT, 
                                                    selling_price FLOAT(6), 
                                                    designation VARCHAR(30), 
                                                    PRIMARY KEY (sandwich_id)
                                                    )`); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Orders.sandwich_ingredients (
                                                    sandwich_id INT NOT NULL, 
                                                    ingredient_id INT NOT NULL, 
                                                    PRIMARY KEY (sandwich_id, ingredient_id), 
                                                    FOREIGN KEY (sandwich_id) REFERENCES sandwiches(sandwich_id)
                                                    )`);
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Orders.sandwich_descriptions (
                                                    sandwich_id INT NOT NULL, 
                                                    text VARCHAR(500), 
                                                    language VARCHAR(5), 
                                                    PRIMARY KEY (sandwich_id, language), 
                                                    FOREIGN KEY (sandwich_id) REFERENCES sandwiches(sandwich_id)
                                                    )`);
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Orders.stores (
                                                    store_id INT NOT NULL AUTO_INCREMENT, 
                                                    designation VARCHAR(255),
                                                    dateOfCreation VARCHAR(255),
                                                    PRIMARY KEY (store_id,designation))`); 

    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Orders.stores_address (
                                                    address_id INT NOT NULL AUTO_INCREMENT,
                                                    store_id INT NOT NULL,
                                                    zipCode VARCHAR(255),
                                                    streetName VARCHAR(255), 
                                                    doorNumber INT, 
                                                    location VARCHAR(255), 
                                                    country VARCHAR(255), 
                                                    PRIMARY KEY (address_id), 
                                                    FOREIGN KEY (store_id) REFERENCES stores(store_id))`);

    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Orders.closingHours (
                                                    closingHours_id INT NOT NULL AUTO_INCREMENT,
                                                    store_id INT NOT NULL,
                                                    dayOfTheWeek VARCHAR(255),
                                                    hour INT, 
                                                    minute INT, 
                                                    PRIMARY KEY (closingHours_id), 
                                                    FOREIGN KEY (store_id) REFERENCES stores(store_id))`); 

    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Orders.openingHours (
                                                    openingHours_id INT NOT NULL AUTO_INCREMENT,
                                                    store_id INT NOT NULL,
                                                    dayOfTheWeek VARCHAR(255),
                                                    hour INT, 
                                                    minute INT, 
                                                    PRIMARY KEY (openingHours_id), 
                                                    FOREIGN KEY (store_id) REFERENCES stores(store_id))`);      
}

public isolated function addOrder(model:OrderDTO orderObject) returns model:OrderObject?|error|model:NotFoundError|model:ValidationError|int{
    int|model:NotFoundError|error lastIdInserted = addOrderToDB(orderObject);
    int n= 0;
    if lastIdInserted is int{
        n = lastIdInserted;
    }
    io:print(n);
    foreach model:OrderItemDTO o in orderObject.items {
        sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO orders_items (order_id, sandwich_id, quantity) VALUES (${n}, ${o.sandwichId}, ${o.quantity})`);
    }
    model:OrderObject|error|model:NotFoundError or = getOrderById(n);
    return or;


}

public isolated function updateOrderById(int id) returns model:OrderObject?|error|model:NotFoundError|model:ValidationError|int|model:Conflict{
    model:OrderInfo|error info = findOrderByIdFromDB(id);
    if info is error{
           return notFound("ORDER_NOT_FOUND","The searched sandwich has not founded");
    }
    else{
        if info.status == "PENDING"{
            string newStatus = "PROCESSING";
            _ = check dbClient->execute(`UPDATE orders SET status=${newStatus} WHERE order_id = ${id}`);
        }
        else if info.status == "PROCESSING" {
            string newStatus = "DONE";
            _ = check dbClient->execute(`UPDATE orders SET status=${newStatus} WHERE order_id = ${id}`);
        }
        else if info.status == "DONE"{
            string newStatus = "DELIVERED";
            _ = check dbClient->execute(`UPDATE orders SET status=${newStatus} WHERE order_id = ${id}`);
        }
        else {
            return conflictError("ORDER_ALREADY_DELIVERED","The order was already delivered to the client");
        }
    }
    model:OrderObject|error|model:NotFoundError or = getOrderById(id);
    return or;

}

public isolated function updateUserOrderById(int id) returns model:OrderObject?|error|model:NotFoundError|model:ValidationError|int|model:Conflict{
    model:OrderInfo|error info = findOrderByIdFromDB(id);
    if info is error{
           return notFound("ORDER_NOT_FOUND","The searched sandwich has not founded");
    }
    else{
        if info.status == "PENDING"{
            string newStatus = "CANCELED";
            _ = check dbClient->execute(`UPDATE orders SET status=${newStatus} WHERE order_id = ${id}`);
        }
        else {
            return conflictError("ORDER_ATIVE","The order is been made, has made or has delivered");
        }
    }
    model:OrderObject|error|model:NotFoundError or = getOrderById(id);
    return or;

}

public isolated function getOrderById(int id) returns model:OrderObject|error|model:NotFoundError{
    model:OrderInfo|error info = findOrderByIdFromDB(id);
    if info is error{
           return notFound("ORDER_NOT_FOUND","The searched sandwich has not founded");
    } 
    model:OrderItem[]|error array = findOrderItemsByIdFromDB(id);
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
    model:OrderObject[] orders = [];
    int[]|error array = findOrdersByIdsFromDB();
    if array is error{
        return notFound("ORDERS_NOT_FOUND","No sandwiches were found");
    }
    foreach int n in array {
        model:OrderObject?|error|model:NotFoundError sand = getOrderById(n);
        orders.push(<model:OrderObject>check sand);
    }
    return orders;
}

public isolated function findOrdersByIdsFromDB() returns int[]|error{
    model:OrderInfo[] infos = [];
    int[] array = [];
    stream<model:OrderInfo, sql:Error?> resultStream = dbClient->query(`SELECT * from orders`);
    check from model:OrderInfo info in resultStream
        do {
            infos.push(info);
        };
    check resultStream.close();
    foreach model:OrderInfo n in infos {
        array.push(n.order_id);
        
    }
    return array;
}

public isolated function getOrdersByUserId(int id) returns model:OrderObject[]|error|model:NotFoundError{
    model:OrderObject[] orders = [];
    int[]|error array = findOrdersByUserFromDB(id);
    if array is error{
        return notFound("ORDERS_NOT_FOUND","No orders were found");
    }
    foreach int n in array {
        model:OrderObject?|error|model:NotFoundError sand = getOrderById(n);
        orders.push(<model:OrderObject>check sand);
    }
    return orders;

}

public isolated function getOrdersByStoreId(int id) returns model:OrderObject[]|error|model:NotFoundError{
    model:OrderObject[] orders = [];
    int[]|error array = findOrdersByStoreFromDB(id);
    if array is error{
        return notFound("ORDERS_NOT_FOUND","No orders were found");
    }
    foreach int n in array {
        model:OrderObject?|error|model:NotFoundError sand = getOrderById(n);
        orders.push(<model:OrderObject>check sand);
    }
    return orders;

}

public isolated function findOrdersByUserFromDB(int id) returns int[]|error{
    model:OrderInfo[] infos = [];
    int[] array = [];
    stream<model:OrderInfo, sql:Error?> resultStream = dbClient->query(`SELECT * from orders where user_id=${id}`);
    check from model:OrderInfo info in resultStream
        do {
            infos.push(info);
        };
    check resultStream.close();
    foreach model:OrderInfo n in infos {
        array.push(n.order_id);
        
    }
    return array;
}

public isolated function findOrdersByStoreFromDB(int id) returns int[]|error{
    model:OrderInfo[] infos = [];
    int[] array = [];
    stream<model:OrderInfo, sql:Error?> resultStream = dbClient->query(`SELECT * from orders where store_id=${id}`);
    check from model:OrderInfo info in resultStream
        do {
            infos.push(info);
        };
    check resultStream.close();
    foreach model:OrderInfo n in infos {
        array.push(n.order_id);
        
    }
    return array;
}

public isolated function findOrderByIdFromDB(int id) returns model:OrderInfo|error{ 
    model:OrderInfo|error ing = check dbClient->queryRow( `SELECT * FROM orders WHERE order_id = ${id}`);
    return ing;
}

public isolated function findOrderItemsByIdFromDB(int id) returns model:OrderItem[]|error{
    model:OrderItem[] items = [];
    stream<model:OrderItem, sql:Error?> resultStream = dbClient->query(`SELECT orderItem_id, sandwich_id, quantity FROM orders_items where order_id = ${id}`);
    check from model:OrderItem des in resultStream
        do {
            items.push(des);
        };
    check resultStream.close();
    return items;
}

public isolated function addOrderToDB(model:OrderDTO orderObject) returns int|model:NotFoundError|error{
    string status = "PENDING";
    sql:ExecutionResult result = check dbClient->execute(`INSERT INTO orders (store_id, user_id, status, dateOfCreation) VALUES (${orderObject.store_id}, ${orderObject.user_id}, ${status}, ${time:utcNow()})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int{
        return lastInsertId;
    }
    else {
        return notFound("INGREDIENT_ID_NOT_FOUND","The searched ingredient has not founded");
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

public isolated function addSandwich(model:Sandwich sand) returns error?{
    sql:ExecutionResult result = check dbClient->execute(`INSERT INTO sandwiches (selling_price, designation) VALUES (${sand.selling_price}, ${sand.designation})`);
    int|string? lastInsertId = result.lastInsertId;
    int n = 0;
    if lastInsertId is int{
        n = lastInsertId;
    }
    foreach int ingrediend_id in sand.ingredients_id {
        sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO sandwich_ingredients (sandwich_id, ingredient_id) VALUES (${n}, ${ingrediend_id})`);
    }
    foreach model:Description description in sand.descriptions {
        sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO sandwich_descriptions (sandwich_id , text, language) VALUES (${n}, ${description.text}, ${description.language})`);
    }
}

public isolated function addStore(model:StoreDTO store) returns error?{
    sql:ExecutionResult result = check dbClient->execute(`INSERT INTO stores (designation, dateOfCreation) VALUES (${store.designation}, ${time:utcNow()})`);
    int|string? lastInsertId = result.lastInsertId;
    int n= 0;
    if lastInsertId is int{
        n = lastInsertId;
    }
    model:Address a ={
        "zipCode":store.address.zipCode,
        "streetName":store.address.streetName,
        "doorNumber":store.address.doorNumber,
        "location":store.address.location,
        "country":store.address.country
    };
    sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO stores_address (store_id, zipCode, streetName, doorNumber, location, country) VALUES 
    (${n}, ${a.zipCode},${a.streetName},${a.doorNumber},${a.location},${a.country})`);

    foreach model:ClosingHours closing in store.closingHours {
         sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO closingHours (store_id, dayOfTheWeek, hour, minute) VALUES (${n}, ${closing.dayOfTheWeek},${closing.hour},${closing.minute})`);
    }
    foreach model:OpeningHours opening in store.openingHours {
         sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO openingHours (store_id, dayOfTheWeek, hour, minute) VALUES (${n}, ${opening.dayOfTheWeek},${opening.hour},${opening.minute})`);
    }
}

public isolated function addUser(model:UserDTO user) returns error?{
    sql:ExecutionResult _ = check dbClient->execute(`INSERT INTO users (name, password, taxIdentificationNumber,address,email) VALUES (${user.name}, ${user.password}, ${user.taxIdentificationNumber},${user.address},${user.email})`);
}


