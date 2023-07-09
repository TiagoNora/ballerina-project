## API Documentation

### Ingredient Management

#### US01: Create ingrendient

```http
  POST /ingredients
```
Payload: **JSON**

```json
{
    "designation": "Designation",
}
```

| Status  | Description   |
| :---------- | :--------- |
| `201`      | `Ingredient created` |
| `400`      | `Ingredient duplicated` |
| `404`      | `Ingredient id not found` |

**If 201 returns:**
```json
{
    "ingredient_id": id,
    "designation": "Designation"
}
```
#### US02: Get ingrendient by id

```http
  GET /ingredients/searchById?id={id}
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `int` | **Required** |

| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Ingredient found` |
| `404`      | `Ingredient not found` |

**If 200 returns:**
```json
{
    "ingredient_id": id,
    "designation": "Designation"
}
```

#### US03: Get ingrendient by designation

```http
  GET /ingredients/searchByDesignation?designation={designation}
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `designation`      | `string` | **Required** |

| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Ingredient found` |
| `404`      | `Ingredient not found` |

**If 200 returns:**
```json
{
    "ingredient_id": id,
    "designation": "Designation"
}
```

#### US04: Get all ingrendients

```http
  GET /ingredients
```

| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Ingredient or ingredients found` |
| `404`      | `Ingredient or ingredients not found` |

**If 200 returns:**
```json
[{
    "ingredient_id": id,
    "designation": "Designation"
},
{
    "ingredient_id": id1,
    "designation": "Designation1"
}]
```

#### US05: Create sandwich

```http
  POST /sandwiches
```

Payload: **JSON**

```json
{
    "designation": "Designation",
    "selling_price": 1.99,
    "ingredients_id": [1,2,3,4],
    "descriptions": [{
                        "language": "en",
                        "text": "Good sandwich to enjoy in the afthernoon"}]
}
```

| Status  | Description   |
| :---------- | :--------- |
| `201`      | `Sandwich created` |
| `400`      | `Ingredient duplicated` or `Description duplicated` |
| `404`      | `Ingredient id not found` or `Sandwich id not found`|

**If 201 returns:**
```json
{
    "sandwich_id": 1,
    "designation": "Designation",
    "selling_price": 1.99,
    "ingredients_id": [1,2,3,4],
    "descriptions": [{
                        "language": "en",
                        "text": "Good sandwich to enjoy in the afthernoon"}]
}
```

#### US06: Get sandwich by id

```http
  GET /sandwiches/searchById?id={id}
```
| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `int` | **Required** |

| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Sandwich found` |
| `404`      | `Sandwich not found` |

**If 200 returns:**
```json
{
    "sandwich_id": 1,
    "designation": "Designation",
    "selling_price": 1.99,
    "ingredients_id": [1,2,3,4],
    "descriptions": [{
                        "language": "en",
                        "text": "Good sandwich to enjoy in the afthernoon"}]
}
```

#### US07: Get all sandwiches

```http
  GET /sandwiches
```

| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Sandwich or sandwiches found` |
| `404`      | `Sandwich or Sandwiches not found` |

**If 200 returns:**
```json
[{
    "sandwich_id": 1,
    "designation": "Designation",
    "selling_price": 1.99,
    "ingredients_id": [1,2,3,4],
    "descriptions": [{
                        "language": "en",
                        "text": "Good sandwich to enjoy in the afthernoon"}]
}]
```

#### US08: Add ingrendient or ingrendients to sandwich

```http
  POST /sandwiches/ingredients?id={id}
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `int` | **Required** |

Payload: **JSON**

```json
{
	"ingredients_id": [5]
}
```

| Status  | Description   |
| :---------- | :--------- |
| `201`      | `Ingredients or ingredient added` |
| `400`      | `Ingredient duplicated` |
| `404`      | `Sandwich id not found` or `Ingredient id not found`|

**If 201 returns:**
```json
{
    "sandwich_id": 1,
    "designation": "Designation",
    "selling_price": 1.99,
    "ingredients_id": [1,2,3,4,5],
    "descriptions": [{
                        "language": "en",
                        "text": "Good sandwich to enjoy in the afthernoon"}]
}
```

#### US09: Add description or descriptions to sandwich

```http
  POST /sandwiches/descriptions?id={id}
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `int` | **Required** |

Payload: **JSON**

```json
{
	"descriptions": [{
		"text": "Uma boa sanduíche para desfrutar à tarde",
		"language": "pt"}]
}
```

| Status  | Description   |
| :---------- | :--------- |
| `201`      | `Description or descriptions added` |
| `400`      | `Description duplicated` |
| `404`      | `Sandwich id not found` |

**If 201 returns:**
```json
{
    "sandwich_id": 1,
    "designation": "Designation",
    "selling_price": 1.99,
    "ingredients_id": [1,2,3,4,5],
    "descriptions": [{
                        "language": "en",
                        "text": "Good sandwich to enjoy in the afthernoon"
                      },
                      {
                        "language": "pt",
                        "text": "Uma boa sanduíche para desfrutar à tarde"
                      }]
}
```

#### US10: Get all sandwiches that doesn´t have a particular ingrendient

```http
  GET /sandwiches/searchWithoutId?id={id}
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `int` | **Required** |


| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Description or descriptions added` |
| `404`      | `Sandwiches or sandwich not found` |

**If 201 returns:**
```json
[{
    "sandwich_id": 1,
    "designation": "Designation",
    "selling_price": 1.99,
    "ingredients_id": [1,2,3,4,5],
    "descriptions": [{
                        "language": "en",
                        "text": "Good sandwich to enjoy in the afthernoon"
                      },
                      {
                        "language": "pt",
                        "text": "Uma boa sanduíche para desfrutar à tarde"
                      }]
}]
```

#### US11: Add customer

```http
  POST /users
```
Payload: **JSON**

```json
{
	"name":"ExempleName",
	"password": "Exemple",
	"taxIdentificationNumber": "123456789",
	"address": "Exemple",
	"email": "Exemple"
}
```

| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Customer added` |
| `404`      | `Customer not found` |

**If 201 returns:**
```json
{
  "user_id": 1,
	"name":"ExempleName",
	"password": "Exemple",
	"taxIdentificationNumber": "123456789",
	"address": "Exemple",
	"email": "Exemple"
}
```

#### US12: Get customer by id

```http
  GET /users/searchById?id=id
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `int` | **Required** |


| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Customer found` |
| `404`      | `Customer not found` |

**If 200 returns:**
```json
{
  "user_id": 1,
	"name":"ExempleName",
	"password": "Exemple",
	"taxIdentificationNumber": "123456789",
	"address": "Exemple",
	"email": "Exemple",
  "permissions": [
        "CUSTOMER"
    ]
}
```

#### US13: Get customer by email

```http
  GET /users/searchByEmail?email=email
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `int` | **Required** |


| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Customer found` |
| `404`      | `Customer not found` |

**If 200 returns:**
```json
{
  "user_id": 1,
	"name":"ExempleName",
	"password": "Exemple",
	"taxIdentificationNumber": "123456789",
	"address": "Exemple",
	"email": "Exemple",
  "permissions": [
        "CUSTOMER"
    ]
}
```

#### US14: Get customer by tax identification number

```http
  GET /users/searchByTaxIdentificationNumber?tax=randomIdentificationNumber
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `int` | **Required** |


| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Customer found` |
| `404`      | `Customer not found` |

**If 200 returns:**
```json
{
  "user_id": 1,
	"name":"ExempleName",
	"password": "Exemple",
	"taxIdentificationNumber": "123456789",
	"address": "Exemple",
	"email": "Exemple",
  "permissions": [
        "CUSTOMER"
    ]
}
```

#### US15: Get customer authentication data

```http
  GET /users/autenticationData?id=idUser
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `int` | **Required** |


| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Customer found` |
| `404`      | `Customer not found` |

**If 200 returns:**
```json
{
  "permissions": [
        "CUSTOMER"
    ]
}
```

#### US16: Get all customers

```http
  GET /users/
```


| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Customer or customers found` |
| `404`      | `Customer or customers not found` |

**If 200 returns:**
```json
[{
  "user_id": 1,
	"name":"ExempleName",
	"password": "Exemple",
	"taxIdentificationNumber": "123456789",
	"address": "Exemple",
	"email": "Exemple",
  "permissions": [
        "CUSTOMER"
    ]
}
{
  "user_id": 2,
	"name":"ExempleName",
	"password": "Exemple",
	"taxIdentificationNumber": "123456789",
	"address": "Exemple",
	"email": "Exemple",
  "permissions": [
        "CUSTOMER"
    ]
}
]
```

#### US17: Add permissions to user

```http
  POST /users/permissions
```


| Status  | Description   |
| :---------- | :--------- |
| `201`      | `Permission added` |
| `404`      | `Sandwiches or sandwich not found` |

**If 201 returns:**
```json
{
    "user_id": 79,
    "name": "Lance Kilback",
    "taxIdentificationNumber": "423707376",
    "address": "68370 Eudora Estates",
    "email": "larissa.zemlak@example.com",
    "permissions": [
        "ADMIN",
        "CUSTOMER"
    ]
}
```

#### US18: Generate JWT
```http
  GET /sandwiches/searchWithoutId?id={id}
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `int` | **Required** |


| Status  | Description   |
| :---------- | :--------- |
| `201`      | `JWT generated` |
| `404`      | `Error when generating jwt` |

**If 201 returns:**
```json
STRING
```

#### US19: Add review of a ordered sandwich

```http
  POST /reviews
```
Payload: **JSON**

```json
{
    "sandwich_id": 1,
    "comment": "test1",
    "rating": 5
}
```

| Status  | Description   |
| :---------- | :--------- |
| `201`      | `Review added` |
| `404`      | `Customer not found` |

**If 201 returns:**
```json
{
    "review_id": 79,
    "user_id": 1,
    "sandwich_id": 1,
    "dateOfCreation": "2023-07-09 22:23:56.393",
    "comment": "test1",
    "rating": 5,
    "upvotes": 0,
    "downvotes": 0,
    "status": "Created"
}
```

#### US22: Create shop

```http
  POST /stores
```
Payload: **JSON**

```json
{
    "designation": "designation",
    "address":{
        "zipCode": "4000-000",
        "streetName": "Teste",
        "doorNumber": 1,
        "location": "location",
        "country": "TesteTeste"
    },
    "openingHours":[{
        "dayOfTheWeek": "Segunda",
        "hour": 8,
        "minute": 0},
        {"dayOfTheWeek": "Terça",
        "hour": 8,
        "minute": 0
        },
        {"dayOfTheWeek": "Quarta",
        "hour": 8,
        "minute": 0
        },
        {"dayOfTheWeek": "Quinta",
        "hour": 8,
        "minute": 0
        },
        {"dayOfTheWeek": "Sexta",
        "hour": 8,
        "minute": 0
        },
        {"dayOfTheWeek": "Sabado",
        "hour": 8,
        "minute": 0
        },
        {"dayOfTheWeek": "Domingo",
        "hour": 8,
        "minute": 0
        }
    ],
    "closingHours":[{
        "dayOfTheWeek": "Segunda",
        "hour": 20,
        "minute": 0},
        {"dayOfTheWeek": "Terça",
        "hour": 20,
        "minute": 0
        },
        {"dayOfTheWeek": "Quarta",
        "hour": 20,
        "minute": 0
        },
        {"dayOfTheWeek": "Quinta",
        "hour": 20,
        "minute": 0
        },
        {"dayOfTheWeek": "Sexta",
        "hour": 20,
        "minute": 0
        },
        {"dayOfTheWeek": "Sabado",
        "hour": 20,
        "minute": 0
        },
        {"dayOfTheWeek": "Domingo",
        "hour": 20,
        "minute": 0
        }
    ]
}
```

| Status  | Description   |
| :---------- | :--------- |
| `201`      | `Store added` |
| `404`      | `Customer not found` |

**If 201 returns:**
```json
{
    "store_id": 60,
    "designation": "hacking",
    "dateOfCreation": "2023-07-09 22:25:50.971",
    "address": {
        "zipCode": "4000-000",
        "streetName": "Teste",
        "doorNumber": 1,
        "location": "New Dawsonstad",
        "country": "TesteTeste"
    },
    "closingHours": [
        {
            "dayOfTheWeek": "Segunda",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Terça",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quarta",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quinta",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sexta",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sabado",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Domingo",
            "hour": 20,
            "minute": 0
        }
    ],
    "openingHours": [
        {
            "dayOfTheWeek": "Segunda",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Terça",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quarta",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quinta",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sexta",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sabado",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Domingo",
            "hour": 8,
            "minute": 0
        }
    ]
}
```

#### US24: List shop by id

```http
  GET /stores/searchById?id=id
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `int` | **Required** |


| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Shop found` |
| `404`      | `Shop not found` |

**If 200 returns:**
```json
{
    "store_id": 60,
    "designation": "hacking",
    "dateOfCreation": "2023-07-09 22:25:50.971",
    "address": {
        "zipCode": "4000-000",
        "streetName": "Teste",
        "doorNumber": 1,
        "location": "New Dawsonstad",
        "country": "TesteTeste"
    },
    "closingHours": [
        {
            "dayOfTheWeek": "Segunda",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Terça",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quarta",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quinta",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sexta",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sabado",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Domingo",
            "hour": 20,
            "minute": 0
        }
    ],
    "openingHours": [
        {
            "dayOfTheWeek": "Segunda",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Terça",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quarta",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quinta",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sexta",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sabado",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Domingo",
            "hour": 8,
            "minute": 0
        }
    ]
}
```
### US25: List shop by designation

```http
  GET /stores/searchByDesignation?designation=designation
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `designation`      | `string` | **Required** |


| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Shop found` |
| `404`      | `Shop not found` |

**If 200 returns:**
```json
{
    "store_id": 60,
    "designation": "hacking",
    "dateOfCreation": "2023-07-09 22:25:50.971",
    "address": {
        "zipCode": "4000-000",
        "streetName": "Teste",
        "doorNumber": 1,
        "location": "New Dawsonstad",
        "country": "TesteTeste"
    },
    "closingHours": [
        {
            "dayOfTheWeek": "Segunda",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Terça",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quarta",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quinta",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sexta",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sabado",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Domingo",
            "hour": 20,
            "minute": 0
        }
    ],
    "openingHours": [
        {
            "dayOfTheWeek": "Segunda",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Terça",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quarta",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quinta",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sexta",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sabado",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Domingo",
            "hour": 8,
            "minute": 0
        }
    ]
}
```
#### US26: List shop by address

```http
  GET /stores/searchByLocation?location=location
```

| Parameter  | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `location`      | `int` | **Required** |


| Status  | Description   |
| :---------- | :--------- |
| `200`      | `Shop found` |
| `404`      | `Shop not found` |

**If 200 returns:**
```json
{
    "store_id": 60,
    "designation": "hacking",
    "dateOfCreation": "2023-07-09 22:25:50.971",
    "address": {
        "zipCode": "4000-000",
        "streetName": "Teste",
        "doorNumber": 1,
        "location": "New Dawsonstad",
        "country": "TesteTeste"
    },
    "closingHours": [
        {
            "dayOfTheWeek": "Segunda",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Terça",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quarta",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quinta",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sexta",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sabado",
            "hour": 20,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Domingo",
            "hour": 20,
            "minute": 0
        }
    ],
    "openingHours": [
        {
            "dayOfTheWeek": "Segunda",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Terça",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quarta",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Quinta",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sexta",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Sabado",
            "hour": 8,
            "minute": 0
        },
        {
            "dayOfTheWeek": "Domingo",
            "hour": 8,
            "minute": 0
        }
    ]
}
```