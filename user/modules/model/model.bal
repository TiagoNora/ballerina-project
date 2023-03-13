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
    string password;
    string taxIdentificationNumber;
    string address;
    string email;
};

public type User record {
    int user_id;
    string name;
    string taxIdentificationNumber;
    string address;
    string email;
    string[] permissions;
};
public type N record {
    string perm;
};

public type Login record {
   string email;
   string password;
};