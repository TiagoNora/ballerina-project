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

public type Sandwich record {
    int sandwich_id;
    float selling_price;
    string designation;
    int[] ingredients_id;
    Description[] descriptions;
};

public type Address record {
    string zipCode;
    string streetName;
    int doorNumber;
    string location;
    string country;
};

public type StoreDTO record {
    string designation;
    Address address;
    ClosingHours[] closingHours;
    OpeningHours[] openingHours;
};

public type UserDTO record {
    string name;
    string password;
    string taxIdentificationNumber;
    string address;
    string email;
};


public type ClosingHours record {
    string dayOfTheWeek;
    int hour;
    int minute;
};

public type OpeningHours record {
    string dayOfTheWeek;
    int hour;
    int minute;
};

public type Description record {
    string text;
    string language;
};

public type OrderDTO record {
   int store_id;
   int user_id;
   OrderItemDTO[] items;
};

public type OrderInfo record {
   int store_id;
   int user_id;
   int order_id;
   string status;
   string dateOfCreation;
};

public type OrderItemDTO record{
   int sandwichId;
   int quantity;
};

public type OrderObject record {
   int order_id;
   int store_id;
   int user_id;
   string status;
   string dateOfCreation;
   OrderItem[] items;
};

public type OrderItem record{
   int orderItem_id;
   int sandwich_id;
   int quantity;
};