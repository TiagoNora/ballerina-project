import ballerinax/rabbitmq;
import orderService.model;
import orderService.repository;
service "sanduiches" on new rabbitmq:Listener(rabbitmq:DEFAULT_HOST, rabbitmq:DEFAULT_PORT) {

    remote function onMessage(model:Sandwich sand) returns error? {
        _ = check repository:addSandwich(sand);
    }
}

service "stores" on new rabbitmq:Listener(rabbitmq:DEFAULT_HOST, rabbitmq:DEFAULT_PORT) {

    remote function onMessage(model:StoreDTO store) returns error? {
        _ = check repository:addStore(store);
    }
}

service "users" on new rabbitmq:Listener(rabbitmq:DEFAULT_HOST, rabbitmq:DEFAULT_PORT) {

    remote function onMessage(model:UserDTO user) returns error? {
        _ = check repository:addUser(user);
    }
}