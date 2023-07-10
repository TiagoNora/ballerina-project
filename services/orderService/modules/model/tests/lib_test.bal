import ballerina/test;

@test:Config {}
function testOrder() {
    OrderDTO orderO = {
        store_id: 1,
        user_id: 1,
        items:[{
            sandwichId: 1,
            quantity: 1
        }]
    };
    test:assertEquals(orderO.store_id, 1);
    test:assertEquals(orderO.user_id, 1);
    test:assertEquals(orderO.items[0].sandwichId,1);
    test:assertEquals(orderO.items[0].quantity,1);

}

@test:Config {}
function testOrderWrongStoreId() {
    OrderDTO orderO = {
        store_id: 1,
        user_id: 1,
        items:[{
            sandwichId: 1,
            quantity: 1
        }]
    };
    test:assertNotEquals(orderO.store_id, 2);
    test:assertEquals(orderO.user_id, 1);
    test:assertEquals(orderO.items[0].sandwichId,1);
    test:assertEquals(orderO.items[0].quantity,1);

}

@test:Config {}
function testOrderWrongUserId() {
    OrderDTO orderO = {
        store_id: 1,
        user_id: 1,
        items:[{
            sandwichId: 1,
            quantity: 1
        }]
    };
    test:assertEquals(orderO.store_id, 1);
    test:assertNotEquals(orderO.user_id, 2);
    test:assertEquals(orderO.items[0].sandwichId,1);
    test:assertEquals(orderO.items[0].quantity,1);

}

@test:Config {}
function testOrderWrongSandwichId() {
    OrderDTO orderO = {
        store_id: 1,
        user_id: 1,
        items:[{
            sandwichId: 1,
            quantity: 1
        }]
    };
    test:assertNotEquals(orderO.store_id, 1);
    test:assertEquals(orderO.user_id, 1);
    test:assertNotEquals(orderO.items[0].sandwichId,2);
    test:assertEquals(orderO.items[0].quantity,1);

}

@test:Config {}
function testOrderWrongQuantity() {
    OrderDTO orderO = {
        store_id: 1,
        user_id: 1,
        items:[{
            sandwichId: 1,
            quantity: 1
        }]
    };
    test:assertNotEquals(orderO.store_id, 1);
    test:assertEquals(orderO.user_id, 1);
    test:assertNotEquals(orderO.items[0].sandwichId,1);
    test:assertNotEquals(orderO.items[0].quantity,2);

}


