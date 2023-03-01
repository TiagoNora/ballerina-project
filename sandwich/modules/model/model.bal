import ballerina/http;
public type Sandwich record {
    int sandwich_id;
    float selling_price;
    string designation;
    int[] ingredients_id;
    Description[] descriptions;
};

public type SandwichInfo record {
    int sandwich_id;
    float selling_price;
    string designation;
};

public type SandwichDTO record {
    string designation;
    float selling_price;
    int[] ingredients_id;
    Description[] descriptions;
};

public type Description record {
    string text;
    string language;
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

public type N record {
    int ingredient_id;
};

public type Ns record {
    int[] ingredients_id;
};

public type Descriptions record {
    Description[] descriptions;
};

public type NQuery record {
    int ingredient_id;
    int sandwich_id;
};