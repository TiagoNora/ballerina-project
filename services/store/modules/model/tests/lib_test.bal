import ballerina/test;
@test:Config {}
function testStore() {
    StoreDTO store = {
        designation: "Test",
        address: {
            zipCode: "4000-000",
            streetName: "Teste",
            doorNumber: 1,
            location: "randomCityStore",
            country: "TesteTeste"
        },
        closingHours:[{
            dayOfTheWeek: "Segunda",
            hour: 20,
            minute: 0
        },
        {
            dayOfTheWeek: "Terça",
            hour: 20,
            minute: 0
        },
        {
            dayOfTheWeek: "Quarta",
            hour: 20,
            minute: 0
        },
        {
            dayOfTheWeek: "Quinta",
            hour: 20,
            minute: 0
        },
        {
            dayOfTheWeek: "Sexta",
            hour: 20,
            minute: 0
        },
        {
            dayOfTheWeek: "Sabado",
            hour: 20,
            minute: 0
        },
        {
            dayOfTheWeek: "Domingo",
            hour: 20,
            minute: 0
        }
    ],
        openingHours:[{
            dayOfTheWeek: "Segunda",
            hour: 8,
            minute: 0
        },
        {
            dayOfTheWeek: "Terça",
            hour: 8,
            minute: 0
        },
        {
            dayOfTheWeek: "Quarta",
            hour: 8,
            minute: 0
        },
        {
            dayOfTheWeek: "Quinta",
            hour: 8,
            minute: 0
        },
        {
            dayOfTheWeek: "Sexta",
            hour: 8,
            minute: 0
        },
        {
            dayOfTheWeek: "Sabado",
            hour: 8,
            minute: 0
        },
        {
            dayOfTheWeek: "Domingo",
            hour: 8,
            minute: 0
        }
    ]
    };
    test:assertEquals(store.designation, "Test");
    test:assertEquals(store.address.zipCode, "4000-000");
    test:assertEquals(store.address.streetName, "Teste");
    test:assertEquals(store.address.doorNumber, 1);
    test:assertEquals(store.address.location, "randomCityStore");
    test:assertEquals(store.address.country, "TesteTeste");
    test:assertEquals(store.openingHours[0].dayOfTheWeek, "Segunda");
    test:assertEquals(store.openingHours[1].dayOfTheWeek, "Terça");
    test:assertEquals(store.openingHours[2].dayOfTheWeek, "Quarta");
    test:assertEquals(store.openingHours[3].dayOfTheWeek, "Quinta");
    test:assertEquals(store.openingHours[4].dayOfTheWeek, "Sexta");
    test:assertEquals(store.openingHours[5].dayOfTheWeek, "Sabado");
    test:assertEquals(store.openingHours[6].dayOfTheWeek, "Domingo");
    test:assertEquals(store.openingHours[0].hour, 8);
    test:assertEquals(store.openingHours[1].hour, 8);
    test:assertEquals(store.openingHours[2].hour, 8);
    test:assertEquals(store.openingHours[3].hour, 8);
    test:assertEquals(store.openingHours[4].hour, 8);
    test:assertEquals(store.openingHours[5].hour, 8);
    test:assertEquals(store.openingHours[6].hour, 8);
    test:assertEquals(store.openingHours[0].minute, 0);
    test:assertEquals(store.openingHours[1].minute, 0);
    test:assertEquals(store.openingHours[2].minute, 0);
    test:assertEquals(store.openingHours[3].minute, 0);
    test:assertEquals(store.openingHours[4].minute, 0);
    test:assertEquals(store.openingHours[5].minute, 0);
    test:assertEquals(store.openingHours[6].minute, 0);

    test:assertEquals(store.closingHours[0].dayOfTheWeek, "Segunda");
    test:assertEquals(store.closingHours[1].dayOfTheWeek, "Terça");
    test:assertEquals(store.closingHours[2].dayOfTheWeek, "Quarta");
    test:assertEquals(store.closingHours[3].dayOfTheWeek, "Quinta");
    test:assertEquals(store.closingHours[4].dayOfTheWeek, "Sexta");
    test:assertEquals(store.closingHours[5].dayOfTheWeek, "Sabado");
    test:assertEquals(store.closingHours[6].dayOfTheWeek, "Domingo");
    test:assertEquals(store.closingHours[0].hour, 20);
    test:assertEquals(store.closingHours[1].hour, 20);
    test:assertEquals(store.closingHours[2].hour, 20);
    test:assertEquals(store.closingHours[3].hour, 20);
    test:assertEquals(store.closingHours[4].hour, 20);
    test:assertEquals(store.closingHours[5].hour, 20);
    test:assertEquals(store.closingHours[6].hour, 20);
    test:assertEquals(store.closingHours[0].minute, 0);
    test:assertEquals(store.closingHours[1].minute, 0);
    test:assertEquals(store.closingHours[2].minute, 0);
    test:assertEquals(store.closingHours[3].minute, 0);
    test:assertEquals(store.closingHours[4].minute, 0);
    test:assertEquals(store.closingHours[5].minute, 0);
    test:assertEquals(store.closingHours[6].minute, 0);


}