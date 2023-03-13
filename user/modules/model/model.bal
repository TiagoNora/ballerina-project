import ballerina/http;
public type Error record {|
   string code;
   string message;
|};
 
public type ErrorResponse record {|
   Error 'error;
|};
 
public type ValidationError record {|
   *http:BadRequest;
   ErrorResponse body;
|};

public type NotFoundError record {|
   *http:NotFound;
   ErrorResponse body;
|};

public type UserDTO record {
    string name;
    string taxIdentificationNumer;
    string address;
    string email;
    AuthenticationData[] permissions;
};

public type User record {
    int id;
    string name;
    string taxIdentificationNumer;
    string address;
    string email;
    AuthenticationData[] permissions;
};

public type AuthenticationData record {
    string perm;
};