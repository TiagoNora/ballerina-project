import ballerina/http;
import review.model;
import review.repository;
service /reviews on new http:Listener(8095) {

    isolated resource function post .(@http:Payload model:ReviewDTO review) returns model:Conflict|model:Review|model:NotFoundError|error{
        return repository:addReview(review);
    }
    isolated resource function get searchById(int id) returns model:Review?|error|model:NotFoundError {
        return repository:getReviewById(id);
    }
    isolated resource function get searchByUserId(int id) returns model:Review[]?|error|model:NotFoundError {
        return repository:getReviewsByUserId(id);
    }
    isolated resource function get searchBySandwichId(int id) returns model:Review[]?|error|model:NotFoundError {
        return repository:getReviewBySandwichId(id);
    }
    isolated resource function put report(int id) returns model:Conflict|model:Review|model:NotFoundError|error {
        return repository:report(id);
    }
    isolated resource function get reported(int id) returns model:Conflict|model:Review[]|model:NotFoundError|error {
        return repository:reported();
    }
    isolated resource function put admin/reported(@http:Payload model:ApproveOrDeny b) returns model:Conflict|model:Review|model:NotFoundError|error {
        return repository:adminReported(b);
    }
    isolated resource function post vote(@http:Payload model:Vote b) returns model:Conflict|model:Review|model:NotFoundError|error {
        return repository:vote(b);
    }
}