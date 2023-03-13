import ballerinax/mysql;
import ballerinax/mysql.driver as _; 
import ballerina/sql;
import ballerina/http;
import sandwich.model;

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;

final mysql:Client dbClient;

function init() returns error? {
    mysql:Client dbClientCreate = check new(host=HOST, user=USER, password=PASSWORD, port=PORT);
    sql:ExecutionResult _ = check dbClientCreate->execute(`CREATE DATABASE IF NOT EXISTS User`);
    check dbClientCreate.close();

    dbClient = check new(host=HOST, user=USER, password=PASSWORD, port=PORT, database="User"); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS User.users (
                                                    user_id INT NOT NULL AUTO_INCREMENT, 
                                                    name VARCHAR(255), 
                                                    taxIdentificationNumer VARCHAR(255),
                                                    address VARCHAR(255),
                                                    email VARCHAR(255),
                                                    PRIMARY KEY (user_id))`); 
    sql:ExecutionResult _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS User.users_perms (
                                                    user_id INT NOT NULL, 
                                                    perm VARCHAR(255) NOT NULL, 
                                                    PRIMARY KEY (user_id, perm), 
                                                    FOREIGN KEY (user_id) REFERENCES users(user_id))`);                                
}

