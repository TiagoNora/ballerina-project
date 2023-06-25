import ballerinax/mysql;
import ballerinax/mysql.driver as _; 
import ballerina/sql;
import review.model;
import ballerina/time;
import ballerina/io;

string USER = "myUser";
string PASSWORD = "myPassword";
string HOST = "localhost";
int PORT = 3311;

final mysql:Client dbClient;

function init() returns error? {
    mysql:Client dbClientCreate = check new(host=HOST, user=USER, password=PASSWORD, port=PORT);
    sql:ExecutionResult _ = check dbClientCreate->execute(`CREATE DATABASE IF NOT EXISTS Reviews`);
    check dbClientCreate.close();

    dbClient = check new(host=HOST, user=USER, password=PASSWORD, port=PORT, database="Reviews"); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Reviews.reviews (
                                                    review_id INT NOT NULL AUTO_INCREMENT, 
                                                    user_id INT NOT NULL,
                                                    sandwich_id INT NOT NULL,
                                                    rating INT NOT NULL,
                                                    upVotes INT NOT NULL,
                                                    downVotes INT NOT NULL,
                                                    status VARCHAR(255),
                                                    dateOfCreation VARCHAR(255),
                                                    comment VARCHAR(255),
                                                    PRIMARY KEY (review_id))`);
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS Reviews.reviews_users (
                                                    review_id INT NOT NULL , 
                                                    user_id INT NOT NULL,
                                                    state BOOLEAN,
                                                    PRIMARY KEY (review_id,user_id)),
                                                    FOREIGN KEY (review_id) REFERENCES reviews(review_id)`);           
}

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

    int|model:NotFoundError|error lastIdInserted = addReviewToDB(review);
    int n= 0;
    if lastIdInserted is int{
        n = lastIdInserted;
    }
    model:Review|error|model:NotFoundError or = getReviewById(n);
    return or;


}

public isolated function report(int id) returns model:Conflict|model:Review|model:NotFoundError|error{
    error? reviewStatusToDB = updateReviewStatusToDB(id);
    if reviewStatusToDB is error {
        return notFound("REVIEW_ID_NOT_FOUND","The searched review has not founded");
    }
    model:Review|error|model:NotFoundError or = getReviewById(id);
    return or;


}

public isolated function vote(model:Vote v) returns model:Conflict|model:Review|model:NotFoundError|error{
    if v.vote == true{
        error? reviewStatusToDB = updateReviewUpVotesToDB(v.review_id);
        if reviewStatusToDB is error {
            return notFound("REVIEW_ID_NOT_FOUND","The searched review has not founded");
        }
        model:Review|error|model:NotFoundError or = getReviewById(v.review_id);
        return or;
    }
    else {
        error? reviewStatusToDB = updateReviewDownVotesToDB(v.review_id);
        if reviewStatusToDB is error {
            return notFound("REVIEW_ID_NOT_FOUND","The searched review has not founded");
        }
        model:Review|error|model:NotFoundError or = getReviewById(v.review_id);
        return or;
    }
}

public isolated function adminReported(model:ApproveOrDeny b) returns model:Conflict|model:Review|model:NotFoundError|error{
    string status = "CREATED";
    if b.approved == false{
        status = "ELIMINATED";
    }
    error? reviewStatusToDB = updateReviewStatusAdminToDB(b.review_id,status);
    if reviewStatusToDB is error {
        return notFound("REVIEW_ID_NOT_FOUND","The searched review has not founded");
    }
    model:Review|error|model:NotFoundError or = getReviewById(b.review_id);
    return or;


}

public isolated function getReviewById(int n) returns model:Review|error|model:NotFoundError {
    model:Review|error r = check dbClient->queryRow( `SELECT * FROM reviews WHERE review_id = ${n}`);
    return r;
}

public isolated function reported() returns model:Review[]|error|model:NotFoundError {
    model:Review[] reviews = [];
    string status = "REPORTED";
    stream<model:Review, sql:Error?> resultStream = dbClient->query(`SELECT * from reviews where status = ${status}`);
    check from model:Review info in resultStream
        do {
            reviews.push(info);
        };
    check resultStream.close();
    return reviews;
}

public isolated function getReviewsByUserId(int n) returns model:Review[]|error|model:NotFoundError {
    model:Review[] reviews = [];
    stream<model:Review, sql:Error?> resultStream = dbClient->query(`SELECT * from reviews where user_id = ${n}`);
    check from model:Review info in resultStream
        do {
            reviews.push(info);
        };
    check resultStream.close();
    return reviews;
}

public isolated function getReviewBySandwichId(int n) returns model:Review[]|error|model:NotFoundError {
    model:Review[] reviews = [];
    string status = "CREATED";
    stream<model:Review, sql:Error?> resultStream = dbClient->query(`SELECT * from reviews where sandwich_id = ${n} and status = ${status}`);
    check from model:Review info in resultStream
        do {
            reviews.push(info);
        };
    check resultStream.close();
    return reviews;
}


public isolated function addReviewToDB(model:ReviewDTO review) returns int|model:NotFoundError|error{
    int upVotes = 0;
    int downVotes = 0;
    string status = "Created";
    sql:ExecutionResult result = check dbClient->execute(`INSERT INTO reviews (user_id, sandwich_id,rating,upVotes,downVotes,status,dateOfCreation,comment) 
    VALUES (${review.user_id}, ${review.sandwich_id}, ${review.rating}, ${upVotes},${downVotes},${status},${time:utcNow()},${review.comment})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int{
        return lastInsertId;
    }
    else {
        return notFound("REVIEW_ID_NOT_FOUND","The searched review has not founded");
    }

}

public isolated function updateReviewStatusToDB(int id) returns error? {
    string status = "REPORTED";
    sql:ExecutionResult _ = check dbClient->execute(`UPDATE reviews set status = ${status} where review_id=${id}`);
}

public isolated function updateReviewUpVotesToDB(int id) returns error? {
    sql:ExecutionResult _ = check dbClient->execute(`UPDATE reviews set upVotes = upVotes + 1 where review_id=${id}`);
}

public isolated function updateReviewDownVotesToDB(int id) returns error? {
    sql:ExecutionResult _ = check dbClient->execute(`UPDATE reviews set downVotes = downVotes + 1 where review_id=${id}`);
}

public isolated function updateReviewStatusAdminToDB(int id, string status) returns error? {
    sql:ExecutionResult _ = check dbClient->execute(`UPDATE reviews set status = ${status} where review_id=${id}`);
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