import ballerina/io;
import ballerina/test;

// Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("I'm the before suite function!");
}

@test:Config {}
function testSandwich() {
    SandwichDTO sandwich = {designation: "Veggie Delight", selling_price: 5.99, 
                            ingredients_id: [1, 2, 3], 
                            descriptions: [{text: "A delicious vegetarian sandwich"}, 
                                            {text: "Un délicieux sandwich végétarien"}]};
    test:assertEquals(sandwich.designation, "Veggie Delight");
    test:assertEquals(sandwich.selling_price, 5.99);
    test:assertEquals(sandwich.ingredients_id, [1, 2, 3]);
    test:assertEquals(sandwich.ingredients_id[0],1);
    test:assertEquals(sandwich.ingredients_id[1],2);
    test:assertEquals(sandwich.ingredients_id[2],3);
    test:assertEquals(sandwich.descriptions[0].text, "A delicious vegetarian sandwich");
    test:assertEquals(sandwich.descriptions[1].text, "Un délicieux sandwich végétarien");
    test:assertEquals(sandwich.descriptions.length(), 2);
    test:assertEquals(sandwich.ingredients_id.length(), 3);
}

// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("I'm the after suite function!");
}
