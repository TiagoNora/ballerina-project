
# Ballerina project

Welcome to my GitHub project! This project is being developed under the curricular unit of PESTA(internship/project). It will demonstrate how to develop applications in ballerina, a programming language that aims to help developers to build easy and fast cloud-native application.

# Prerequisites

1. Podman
- Install podman in your machine, follow this [link](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md)
- Create the container with the mysql image
- Create a user with all the permissions

2. Ballerina
- Install Ballerina 2201.0.0 (Swan Lake) or greater, the link can be found [here](https://ballerina.io/learn/install-ballerina/set-up-ballerina/)
- Install a text editor like [Visual Studio Code](https://code.visualstudio.com/)

You can check if the installation of Ballerina was successful with the following code:

```
bal version or bal
```
# Open-Source tools and technologies used
- Ballerina (Programming Language)
- Podman (Container manager)
- Mysql (Database)
- Insomnia (API Client)
- JMeter (Load test tool)

## Open and run
1. Open project
- Clone the project
- cd into the global folder
- cd into the application folder

2. Add mysql credentials
- Create in each application a file with the name **Config.toml**
- Inside the file you should have the following format:
```
[nameOfApplication.repository]
USER="secret"
PASSWORD="secret"
HOST="secret"
PORT=secret
```

You should change the spaces that contains the keyword **secret** with your credentials.

3. Run the application
- bal build
- bal run
    
## User Cases

### Ingredient Management
- [x]  US01: Create ingrendient
- [x]  US02: Get ingrendient by id
- [x]  US03: Get ingrendient by designation
- [x]  US04: Get all ingrendients

### Sandwich Management
- [x]  US05: Create sandwich
- [x]  US06: Get sandwich by id
- [x]  US07: Get all sandwiches
- [x]  US08: Add ingrendient or ingrendients to sandwich
- [ ]  US09: Add description or descriptions to sandwich
- [ ]  US10: Get all sandwiches that doesn´t have a particular ingrendient


## Calendar

| Week | Timeframe    | Description                | Comment|
| :-------- | :------- | :------------------------- | :----|
| 1 | 22/02/2023-01/03/2023 | US01-US10 |IN PROGRESS :construction: |


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
}
]
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
                        language: "en"
                        text: "Good sandwich to enjoy in the afthernoon"}]
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
                        language: "en"
                        text: "Good sandwich to enjoy in the afthernoon"}]
}
```

#### US06: Get sandwich by id

```http
  GET /sandwiches/searchById?id={id}
```

#### US07: Get all sandwiches

```http
  GET /sandwiches
```

#### US08: Add ingrendient or ingrendients to sandwich

```http
  POST /sandwiches/ingredients?id={id}
```
#### US09: Add description or descriptions to sandwich

```http
  POST /sandwiches/descriptions?id={id}
```

#### US10: Get all sandwiches that doesn´t have a particular ingrendient

```http
  GET /sandwiches/searchWithoutId?id={id}
```

## License

[MIT](https://choosealicense.com/licenses/mit/)

