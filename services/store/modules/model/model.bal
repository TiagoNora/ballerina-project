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
public type Deleted record {|
   *http:NonAuthoritativeInformation;
   ErrorResponse body;
|};

public type StoreDTO record {
    string designation;
    Address address;
    ClosingHours[] closingHours;
    OpeningHours[] openingHours;
};

public type Store record {
    int store_id;
    string designation;
    string dateOfCreation;
    Address address;
    ClosingHours[] closingHours;
    OpeningHours[] openingHours;
};

public type StoreAux record {
    int store_id;
    string designation;
    string dateOfCreation;
};

public type Address record {
    string zipCode;
    string streetName;
    int doorNumber;
    string location;
    string country;
};

public type AddressAux record {
    int store_id;
    string zipCode;
    string streetName;
    int doorNumber;
    string location;
    string country;
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