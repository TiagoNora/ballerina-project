import ballerinax/rabbitmq;
import sandwich.model;
import sandwich.repository;
service "ingredientes" on new rabbitmq:Listener(rabbitmq:DEFAULT_HOST, rabbitmq:DEFAULT_PORT) {

    remote function onMessage(model:IngredientDTO ingredient) returns error? {
        _ = check repository:addIngredient(ingredient);
    }
}