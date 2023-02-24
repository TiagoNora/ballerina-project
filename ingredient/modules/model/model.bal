import ballerina/http;
public type Ingredient record {
    int ingredient_id?;
    string designation;
};

public type IngredientDTO record {
    string designation;
};

public type Error record {|
   # Error code
   string code;
   # Error message
   string message;
|};
 
# Error response
public type ErrorResponse record {|
   # Error
   Error 'error;
|};
 
# Bad request response
public type ValidationError record {|
   *http:BadRequest;
   # Error response.
   ErrorResponse body;
|};

public type NotFoundError record {|
   *http:NotFound;
   # Error response.
   ErrorResponse body;
|};