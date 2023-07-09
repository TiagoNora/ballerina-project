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

public type Conflict record {|
   *http:Conflict;
   ErrorResponse body;
|};
public type Deleted record {|
   *http:NonAuthoritativeInformation;
   ErrorResponse body;
|};

public type Review record{
   int review_id;
   int user_id;
   int sandwich_id;
   string dateOfCreation;
   string comment;
   int rating;
   int upvotes;
   int downvotes;
   string status;
};

public type ReviewDTO record{
   int user_id;
   int sandwich_id;
   string comment;
   int rating;
};

public type ApproveOrDeny record{
   int review_id;
   boolean approved;
};

public type Sandwich record {
    int sandwich_id;
    float selling_price;
    string designation;
    int[] ingredients_id;
    Description[] descriptions;
};

public type UserDTO record {
    string name;
    string password;
    string taxIdentificationNumber;
    string address;
    string email;
};

public type Description record {
    string text;
    string language;
};

public type Vote record{
   int review_id;
   int user_id;
   boolean vote;
};