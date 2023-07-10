import ballerina/test;
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

@test:Config {}
function testSandwichWrongDesignation() {
    SandwichDTO sandwich = {designation: "Veggie Delight", selling_price: 5.99, 
                            ingredients_id: [1, 2, 3], 
                            descriptions: [{text: "A delicious vegetarian sandwich"}, 
                                            {text: "Un délicieux sandwich végétarien"}]};
    test:assertNotEquals(sandwich.designation, "Veggie");
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

@test:Config {}
function testSandwichWrongSellingPrice() {
    SandwichDTO sandwich = {designation: "Veggie Delight", selling_price: 5.99, 
                            ingredients_id: [1, 2, 3], 
                            descriptions: [{text: "A delicious vegetarian sandwich"}, 
                                            {text: "Un délicieux sandwich végétarien"}]};
    test:assertEquals(sandwich.designation, "Veggie Delight");
    test:assertNotEquals(sandwich.selling_price, 6.00);
    test:assertEquals(sandwich.ingredients_id, [1, 2, 3]);
    test:assertEquals(sandwich.ingredients_id[0],1);
    test:assertEquals(sandwich.ingredients_id[1],2);
    test:assertEquals(sandwich.ingredients_id[2],3);
    test:assertEquals(sandwich.descriptions[0].text, "A delicious vegetarian sandwich");
    test:assertEquals(sandwich.descriptions[1].text, "Un délicieux sandwich végétarien");
    test:assertEquals(sandwich.descriptions.length(), 2);
    test:assertEquals(sandwich.ingredients_id.length(), 3);
}

@test:Config {}
function testSandwichWrongIngredientId() {
    SandwichDTO sandwich = {designation: "Veggie Delight", selling_price: 5.99, 
                            ingredients_id: [1, 2, 3], 
                            descriptions: [{text: "A delicious vegetarian sandwich"}, 
                                            {text: "Un délicieux sandwich végétarien"}]};
    test:assertEquals(sandwich.designation, "Veggie Delight");
    test:assertEquals(sandwich.selling_price, 5.99);
    test:assertNotEquals(sandwich.ingredients_id, [1, 2, 4]);
    test:assertEquals(sandwich.ingredients_id[0],1);
    test:assertEquals(sandwich.ingredients_id[1],2);
    test:assertEquals(sandwich.ingredients_id[2],3);
    test:assertEquals(sandwich.descriptions[0].text, "A delicious vegetarian sandwich");
    test:assertEquals(sandwich.descriptions[1].text, "Un délicieux sandwich végétarien");
    test:assertEquals(sandwich.descriptions.length(), 2);
    test:assertEquals(sandwich.ingredients_id.length(), 3);
}

function testSandwichWrongIngredientId1() {
    SandwichDTO sandwich = {designation: "Veggie Delight", selling_price: 5.99, 
                            ingredients_id: [1, 2, 3], 
                            descriptions: [{text: "A delicious vegetarian sandwich"}, 
                                            {text: "Un délicieux sandwich végétarien"}]};
    test:assertEquals(sandwich.designation, "Veggie Delight");
    test:assertEquals(sandwich.selling_price, 5.99);
    test:assertEquals(sandwich.ingredients_id, [1, 2, 4]);
    test:assertNotEquals(sandwich.ingredients_id[0],2);
    test:assertEquals(sandwich.ingredients_id[1],2);
    test:assertEquals(sandwich.ingredients_id[2],3);
    test:assertEquals(sandwich.descriptions[0].text, "A delicious vegetarian sandwich");
    test:assertEquals(sandwich.descriptions[1].text, "Un délicieux sandwich végétarien");
    test:assertEquals(sandwich.descriptions.length(), 2);
    test:assertEquals(sandwich.ingredients_id.length(), 3);
}

function testSandwichWrongIngredientId2() {
    SandwichDTO sandwich = {designation: "Veggie Delight", selling_price: 5.99, 
                            ingredients_id: [1, 2, 3], 
                            descriptions: [{text: "A delicious vegetarian sandwich"}, 
                                            {text: "Un délicieux sandwich végétarien"}]};
    test:assertEquals(sandwich.designation, "Veggie Delight");
    test:assertEquals(sandwich.selling_price, 5.99);
    test:assertEquals(sandwich.ingredients_id, [1, 2, 4]);
    test:assertEquals(sandwich.ingredients_id[0],1);
    test:assertNotEquals(sandwich.ingredients_id[1],3);
    test:assertEquals(sandwich.ingredients_id[2],3);
    test:assertEquals(sandwich.descriptions[0].text, "A delicious vegetarian sandwich");
    test:assertEquals(sandwich.descriptions[1].text, "Un délicieux sandwich végétarien");
    test:assertEquals(sandwich.descriptions.length(), 2);
    test:assertEquals(sandwich.ingredients_id.length(), 3);
}

function testSandwichWrongIngredientId3() {
    SandwichDTO sandwich = {designation: "Veggie Delight", selling_price: 5.99, 
                            ingredients_id: [1, 2, 3], 
                            descriptions: [{text: "A delicious vegetarian sandwich"}, 
                                            {text: "Un délicieux sandwich végétarien"}]};
    test:assertEquals(sandwich.designation, "Veggie Delight");
    test:assertEquals(sandwich.selling_price, 5.99);
    test:assertEquals(sandwich.ingredients_id, [1, 2, 4]);
    test:assertEquals(sandwich.ingredients_id[0],1);
    test:assertEquals(sandwich.ingredients_id[1],2);
    test:assertNotEquals(sandwich.ingredients_id[2],5);
    test:assertEquals(sandwich.descriptions[0].text, "A delicious vegetarian sandwich");
    test:assertEquals(sandwich.descriptions[1].text, "Un délicieux sandwich végétarien");
    test:assertEquals(sandwich.descriptions.length(), 2);
    test:assertEquals(sandwich.ingredients_id.length(), 3);
}

function testSandwichWrongDescriptionsText1() {
    SandwichDTO sandwich = {designation: "Veggie Delight", selling_price: 5.99, 
                            ingredients_id: [1, 2, 3], 
                            descriptions: [{text: "A delicious vegetarian sandwich"}, 
                                            {text: "Un délicieux sandwich végétarien"}]};
    test:assertEquals(sandwich.designation, "Veggie Delight");
    test:assertEquals(sandwich.selling_price, 5.99);
    test:assertEquals(sandwich.ingredients_id, [1, 2, 4]);
    test:assertEquals(sandwich.ingredients_id[0],1);
    test:assertEquals(sandwich.ingredients_id[1],2);
    test:assertEquals(sandwich.ingredients_id[2],3);
    test:assertNotEquals(sandwich.descriptions[0].text, "A vegetarian sandwich");
    test:assertEquals(sandwich.descriptions[1].text, "Un délicieux sandwich végétarien");
    test:assertEquals(sandwich.descriptions.length(), 2);
    test:assertEquals(sandwich.ingredients_id.length(), 3);
}

function testSandwichWrongDescriptionsText2() {
    SandwichDTO sandwich = {designation: "Veggie Delight", selling_price: 5.99, 
                            ingredients_id: [1, 2, 3], 
                            descriptions: [{text: "A delicious vegetarian sandwich"}, 
                                            {text: "Un délicieux sandwich végétarien"}]};
    test:assertEquals(sandwich.designation, "Veggie Delight");
    test:assertEquals(sandwich.selling_price, 5.99);
    test:assertEquals(sandwich.ingredients_id, [1, 2, 4]);
    test:assertEquals(sandwich.ingredients_id[0],1);
    test:assertEquals(sandwich.ingredients_id[1],2);
    test:assertEquals(sandwich.ingredients_id[2],3);
    test:assertEquals(sandwich.descriptions[0].text, "A vegetarian sandwich");
    test:assertNotEquals(sandwich.descriptions[1].text, "Un sandwich végétarien");
    test:assertEquals(sandwich.descriptions.length(), 2);
    test:assertEquals(sandwich.ingredients_id.length(), 3);
}

function testSandwichWrongDescriptionsLength() {
    SandwichDTO sandwich = {designation: "Veggie Delight", selling_price: 5.99, 
                            ingredients_id: [1, 2, 3], 
                            descriptions: [{text: "A delicious vegetarian sandwich"}, 
                                            {text: "Un délicieux sandwich végétarien"}]};
    test:assertEquals(sandwich.designation, "Veggie Delight");
    test:assertEquals(sandwich.selling_price, 5.99);
    test:assertEquals(sandwich.ingredients_id, [1, 2, 4]);
    test:assertEquals(sandwich.ingredients_id[0],1);
    test:assertEquals(sandwich.ingredients_id[1],2);
    test:assertEquals(sandwich.ingredients_id[2],3);
    test:assertEquals(sandwich.descriptions[0].text, "A vegetarian sandwich");
    test:assertEquals(sandwich.descriptions[1].text, "Un délicieux sandwich végétarien");
    test:assertNotEquals(sandwich.descriptions.length(), 3);
    test:assertEquals(sandwich.ingredients_id.length(), 3);
}

function testSandwichWrongIngredientesLength() {
    SandwichDTO sandwich = {designation: "Veggie Delight", selling_price: 5.99, 
                            ingredients_id: [1, 2, 3], 
                            descriptions: [{text: "A delicious vegetarian sandwich"}, 
                                            {text: "Un délicieux sandwich végétarien"}]};
    test:assertEquals(sandwich.designation, "Veggie Delight");
    test:assertEquals(sandwich.selling_price, 5.99);
    test:assertEquals(sandwich.ingredients_id, [1, 2, 4]);
    test:assertEquals(sandwich.ingredients_id[0],1);
    test:assertEquals(sandwich.ingredients_id[1],2);
    test:assertEquals(sandwich.ingredients_id[2],3);
    test:assertEquals(sandwich.descriptions[0].text, "A vegetarian sandwich");
    test:assertEquals(sandwich.descriptions[1].text, "Un délicieux sandwich végétarien");
    test:assertNotEquals(sandwich.descriptions.length(), 3);
    test:assertEquals(sandwich.ingredients_id.length(), 4);
}
