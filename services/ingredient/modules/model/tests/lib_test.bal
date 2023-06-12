import ballerina/test;

@test:Config {}
function testIngredientDesignation() {
    IngredientDTO ing = {
        designation: "Example"
    };
    test:assertEquals(ing.designation, "Example");
}

@test:Config {}
function testIngredientChangeDesignation() {
    IngredientDTO ing = {
        designation: "Example"
    };
    ing.designation = "Example1";
    test:assertEquals(ing.designation, "Example1");
}


@test:Config {}
function testIngredienteError() {
    IngredientDTO ing = {
        designation: "Example"
    };
    test:assertNotEquals(ing.designation, "Example1");
}

