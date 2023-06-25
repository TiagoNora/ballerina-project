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