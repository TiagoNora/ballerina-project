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
