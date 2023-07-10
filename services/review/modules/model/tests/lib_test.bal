import ballerina/test;

@test:Config {}
function testReview() {
    ReviewDTO review = {
        user_id: 1,
        sandwich_id: 1,
        comment: "Exemple",
        rating: 5
    };

    test:assertEquals(review.user_id, 1);
    test:assertEquals(review.sandwich_id, 1);
    test:assertEquals(review.comment,"Exemple");
    test:assertEquals(review.rating,5);

}

@test:Config {}
function testOrderWrongUserId() {
    ReviewDTO review = {
        user_id: 1,
        sandwich_id: 1,
        comment: "Exemple",
        rating: 5
    };

    test:assertNotEquals(review.user_id, 2);
    test:assertEquals(review.sandwich_id, 1);
    test:assertEquals(review.comment,"Exemple");
    test:assertEquals(review.rating,5);
}

@test:Config {}
function testOrderWrongSandwichId() {
    ReviewDTO review = {
        user_id: 1,
        sandwich_id: 1,
        comment: "Exemple",
        rating: 5
    };

    test:assertEquals(review.user_id, 1);
    test:assertNotEquals(review.sandwich_id, 2);
    test:assertEquals(review.comment,"Exemple");
    test:assertEquals(review.rating,5);
}

@test:Config {}
function testOrderWrongExemple() {
    ReviewDTO review = {
        user_id: 1,
        sandwich_id: 1,
        comment: "Exemple",
        rating: 5
    };

    test:assertEquals(review.user_id, 1);
    test:assertEquals(review.sandwich_id, 1);
    test:assertNotEquals(review.comment,"Exemple1");
    test:assertEquals(review.rating,5);

}

@test:Config {}
function testOrderWrongRating() {
    ReviewDTO review = {
        user_id: 1,
        sandwich_id: 1,
        comment: "Exemple",
        rating: 5
    };

    test:assertEquals(review.user_id, 1);
    test:assertEquals(review.sandwich_id, 1);
    test:assertEquals(review.comment,"Exemple");
    test:assertNotEquals(review.rating,4);
}


