import ballerinax/rabbitmq;
import review.model;
import review.repository;
service "sanduiches" on new rabbitmq:Listener(rabbitmq:DEFAULT_HOST, rabbitmq:DEFAULT_PORT) {

    remote function onMessage(model:Sandwich sand) returns error? {
        _ = check repository:addSandwich(sand);
    }
}

service "users" on new rabbitmq:Listener(rabbitmq:DEFAULT_HOST, rabbitmq:DEFAULT_PORT) {

    remote function onMessage(model:UserDTO user) returns error? {
        _ = check repository:addUser(user);
    }
}