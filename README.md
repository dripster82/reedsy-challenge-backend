# Reedsy Backend Challenge

## To Setup
In order to setup this rails api application:

 - Clone to local system
 - Then from a terminal in the app folder
 - run `bundle install`
 - run `rails db:create` to create the database
 - run `rails db:migrate` to run the migrations
 - run `rails db:seed` to prepopulate the database with initial/default data


## Running the app
to test the app run the rails server with
`rails s`


## Endpoints

### Product List
GET `/api/v1/products`
Response
`{
  "data": [
    {
      "id": "MUG",
      "type": "Product",
      "attributes": {
        "code": "MUG",
        "name": "Reedsy Mug",
        "price": "6.0"
      }
    },
    {
      "id": "TSHIRT",
      "type": "Product",
      "attributes": {
        "code": "TSHIRT",
        "name": "Reedsy T-Shirt",
        "price": "15.0"
      }
    },
    {
      "id": "HOODIE",
      "type": "Product",
      "attributes": {
        "code": "HOODIE",
        "name": "Reedsy Hoodie",
        "price": "20.0"
      }
    }
  ]
}`

### Product Update
PATCH `/api/v1/products/`
Request Body
`{
  "data": {
    "attributes": {
      "price": 3.99
    }
  }
}`

Response
`{
    "data": {
        "id": "MUG",
        "type": "Product",
        "attributes": {
            "code": "MUG",
            "name": "Reedsy Mug",
            "price": "3.99"
        }
    }
}`


### Product Price Check / Quote
POST `/api/v1/products/quote`
Request Body
`{
  "data": [
    { "id": "MUG", "type": "QuoteLine", "attributes": { "qty": 3 } },
    { "id": "HOODIE", "type": "QuoteLine", "attributes": { "qty": 1 } }
  ]
}`

Response
`{
    "data": {
        "id": "temp_quote_id",
        "type": "Quote",
        "attributes": {
            "total_price": "31.97"
        },
        "relationships": {
            "quote_lines": {
                "data": [
                    {
                        "id": "MUG",
                        "type": "QuoteLine"
                    },
                    {
                        "id": "HOODIE",
                        "type": "QuoteLine"
                    }
                ]
            }
        }
    },
    "included": [
        {
            "id": "MUG",
            "type": "QuoteLine",
            "attributes": {
                "code": "MUG",
                "qty": 3,
                "product_price": "3.99",
                "line_price": "3.99",
                "total_price": "11.97",
                "discount_percentage": 0
            }
        },
        {
            "id": "HOODIE",
            "type": "QuoteLine",
            "attributes": {
                "code": "HOODIE",
                "qty": 1,
                "product_price": "20.0",
                "line_price": "20.0",
                "total_price": "20.0",
                "discount_percentage": 0
            }
        }
    ]
}`