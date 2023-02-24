import ballerina/http;
public type Ingredient record {
    int ingredient_id?;
    string designation;
};

public type IngredientDTO record {
    string designation;
};

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