import ballerina/test;

// Before Suite Function

@test:Config {}
function testUser() {
    UserDTO user = {
        name:"Teste",
	    password: "TestePassword",
	    taxIdentificationNumber: "123456789",
	    address: "TesteAddress",
	    email: "TestEmail"
    };
    test:assertEquals(user.name, "Teste");
    test:assertEquals(user.password, "TestePassword");
    test:assertEquals(user.taxIdentificationNumber, "123456789");
    test:assertEquals(user.address, "TesteAddress");
    test:assertEquals(user.email, "TestEmail");

}

@test:Config {}
function testUserWrongName() {
    UserDTO user = {
        name:"Teste",
	    password: "TestePassword",
	    taxIdentificationNumber: "123456789",
	    address: "TesteAddress",
	    email: "TestEmail"
    };
    test:assertNotEquals(user.name, "Teste1");
    test:assertEquals(user.password, "TestePassword");
    test:assertEquals(user.taxIdentificationNumber, "123456789");
    test:assertEquals(user.address, "TesteAddress");
    test:assertEquals(user.email, "TestEmail");

}

@test:Config {}
function testUserWrongPassoword() {
    UserDTO user = {
        name:"Teste",
	    password: "TestePassword",
	    taxIdentificationNumber: "123456789",
	    address: "TesteAddress",
	    email: "TestEmail"
    };
    test:assertEquals(user.name, "Teste");
    test:assertNotEquals(user.password, "TestePassword1");
    test:assertEquals(user.taxIdentificationNumber, "123456789");
    test:assertEquals(user.address, "TesteAddress");
    test:assertEquals(user.email, "TestEmail");

}

@test:Config {}
function testUserWrongTaxIdentificationNumber() {
    UserDTO user = {
        name:"Teste",
	    password: "TestePassword",
	    taxIdentificationNumber: "123456789",
	    address: "TesteAddress",
	    email: "TestEmail"
    };
    test:assertEquals(user.name, "Teste");
    test:assertEquals(user.password, "TestePassword");
    test:assertNotEquals(user.taxIdentificationNumber, "1234567890");
    test:assertEquals(user.address, "TesteAddress");
    test:assertEquals(user.email, "TestEmail");

}

@test:Config {}
function testUserWrongAddress() {
    UserDTO user = {
        name:"Teste",
	    password: "TestePassword",
	    taxIdentificationNumber: "123456789",
	    address: "TesteAddress",
	    email: "TestEmail"
    };
    test:assertEquals(user.name, "Teste");
    test:assertEquals(user.password, "TestePassword");
    test:assertEquals(user.taxIdentificationNumber, "123456789");
    test:assertNotEquals(user.address, "TesteAddress1");
    test:assertEquals(user.email, "TestEmail");

}


@test:Config {}
function testUserWrongEmail() {
    UserDTO user = {
        name:"Teste",
	    password: "TestePassword",
	    taxIdentificationNumber: "123456789",
	    address: "TesteAddress",
	    email: "TestEmail"
    };
    test:assertEquals(user.name, "Teste");
    test:assertEquals(user.password, "TestePassword");
    test:assertEquals(user.taxIdentificationNumber, "T123456789este");
    test:assertEquals(user.address, "TesteAddress");
    test:assertNotEquals(user.email, "TestEmail1");

}


