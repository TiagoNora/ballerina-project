import review.model;
import ballerina/io;
import review.repository;


public isolated function addReview(model:ReviewDTO review) returns model:Conflict|model:Review|model:NotFoundError|error{
    string filePath1 = "./words/file.txt";
    string[] readLines = check io:fileReadLines(filePath1);
    boolean find = false;
    foreach string i in readLines{
        if (i.includes(review.comment)){
            find = true;
        }
    }
    if find == true{
        return conflictError("INVALID_WORD_OR_PHRASE", "The introduzed comment have a forbiden word or phrase");
    }

    int|model:NotFoundError|error lastIdInserted = repository:addReviewToDB(review);
    int n= 0;
    if lastIdInserted is int{
        n = lastIdInserted;
    }
    model:Review|error|model:NotFoundError or = repository:getReviewById(n);
    return or;


}

public isolated function getReviewById(int n) returns model:Review|error|model:NotFoundError {
    model:Review|error|model:NotFoundError r = repository:getReviewById(n);
    return r;
}

public isolated function getReviewsByUserId(int n) returns model:Review[]|error|model:NotFoundError {
    model:Review[]|error|model:NotFoundError reviews = repository:getReviewsByUserId(n);
    return reviews;
}

public isolated function getReviewBySandwichId(int n) returns model:Review[]|error|model:NotFoundError {
    model:Review[]|error|model:NotFoundError reviews = repository:getReviewBySandwichId(n);
    return reviews;
}


public isolated function report(int id) returns model:Conflict|model:Review|model:NotFoundError|error{
    error? reviewStatusToDB = repository:updateReviewStatusToDB(id);
    if reviewStatusToDB is error {
        return notFound("REVIEW_ID_NOT_FOUND","The searched review has not founded");
    }
    model:Review|error|model:NotFoundError or = repository:getReviewById(id);
    return or;


}

public isolated function reported() returns model:Review[]|error|model:NotFoundError {
    model:Review[]|error|model:NotFoundError reviews = repository:reported();
    return reviews;
}

public isolated function adminReported(model:ApproveOrDeny b) returns model:Conflict|model:Review|model:NotFoundError|error{
    string status = "CREATED";
    if b.approved == false{
        status = "ELIMINATED";
    }
    error? reviewStatusToDB = repository:updateReviewStatusAdminToDB(b.review_id,status);
    if reviewStatusToDB is error {
        return notFound("REVIEW_ID_NOT_FOUND","The searched review has not founded");
    }
    model:Review|error|model:NotFoundError or = getReviewById(b.review_id);
    return or;


}

public isolated function vote(model:Vote v) returns model:Conflict|model:Review|model:NotFoundError|error{
    if v.vote == true{
        error? reviewStatusToDB = repository:updateReviewUpVotesToDB(v.review_id);
        if reviewStatusToDB is error {
            return notFound("REVIEW_ID_NOT_FOUND","The searched review has not founded");
        }
        model:Review|error|model:NotFoundError or = getReviewById(v.review_id);
        return or;
    }
    else {
        error? reviewStatusToDB = repository:updateReviewDownVotesToDB(v.review_id);
        if reviewStatusToDB is error {
            return notFound("REVIEW_ID_NOT_FOUND","The searched review has not founded");
        }
        model:Review|error|model:NotFoundError or = getReviewById(v.review_id);
        return or;
    }
}

public isolated function notFound(string codeMessage,string messageError) returns model:NotFoundError{
    return <model:NotFoundError>{
            body: {
                'error: {
                    code: codeMessage,
                    message: messageError
                }
            }
               
    };
}

public isolated function validationError(string codeMessage,string messageError) returns model:ValidationError{
    return <model:ValidationError>{
            body: {
                'error: {
                    code: codeMessage,
                    message: messageError
                }
            }
               
    };
}

public isolated function deleted(string codeMessage,string messageError) returns model:Deleted{
    return <model:Deleted>{
            body: {
                'error: {
                    code: codeMessage,
                    message: messageError
                }
            }
               
    };
}

public isolated function conflictError(string codeMessage,string messageError) returns model:Conflict{
    return <model:Conflict>{
            body: {
                'error: {
                    code: codeMessage,
                    message: messageError
                }
            }
               
    };
}
