import ballerina/http;
import review.model;
import review.serviceReview;
service /reviews on new http:Listener(8095) {

    isolated resource function post .(@http:Payload model:ReviewDTO review) returns model:Conflict|model:Review|model:NotFoundError|error{
        return serviceReview:addReview(review);
    }
    isolated resource function get searchById(int id) returns model:Review?|error|model:NotFoundError {
        return serviceReview:getReviewById(id);
    }
    isolated resource function get searchByUserId(int id) returns model:Review[]?|error|model:NotFoundError {
        return serviceReview:getReviewsByUserId(id);
    }
    isolated resource function get searchBySandwichId(int id) returns model:Review[]?|error|model:NotFoundError {
        return serviceReview:getReviewBySandwichId(id);
    }
    isolated resource function put report(int id) returns model:Conflict|model:Review|model:NotFoundError|error {
        return serviceReview:report(id);
    }
    isolated resource function get reported() returns model:Conflict|model:Review[]|model:NotFoundError|error {
        return serviceReview:reported();
    }
    isolated resource function put admin/reported(@http:Payload model:ApproveOrDeny b) returns model:Conflict|model:Review|model:NotFoundError|error {
        return serviceReview:adminReported(b);
    }
    isolated resource function post vote(@http:Payload model:Vote b) returns model:Conflict|model:Review|model:NotFoundError|error {
        return serviceReview:vote(b);
    }
}