
# Ballerina project

Welcome to my GitHub project! This project is being developed under the curricular unit of PESTA(internship/project). It will demonstrate how to develop applications in ballerina, a programming language that aims to help developers to build easy and fast cloud-native application.

# Context

A group of former students, some with experience in Computer Engineering,
decided to create a company dedicated to selling healthy sandwiches
sandwiches in a physical store. For this, it is necessary to create a computer solution that supports
the company's needs. It is desired to have a system that has the necessary
necessary to manage the various dimensions of the company. In the development
of this prototype an architecture of microservices must be considered, databases must be
databases unique to each microservice and that these should be called through an API Gateway.
through an API Gateway. The application should consist of:
- Sandwich management
- Ingredient management
- Review management
- Store management
- Order management
- Customer management

In the system, each sandwich is identified by a designation, selling price and
a list of ingredients. In addition, it may have several descriptions, but for authorized languages
languages, detected by the application itself. Any sandwich must be created
with a minimum of 3 ingredients, and it is mandatory to contain one type of
bread. The ingredients in the list must be checked for existence.
An ingredient has a name and a category, it is used in the formation of the sandwich.
of the sandwich.
The customer is allowed to create a review, in which he describes his experience after
ordering a sandwich using a comment and a scale of 0 to 5 stars.
5 stars. An initial filtering of the review's content must be done. Other customers can indicate whether they liked or disliked the review, but they can also
report it if they think the review contains offensive content, among others. Afterwards it will be reviewed by an administrator. It must be
accompanied by the time of creation.
A store includes a store name, address and the person in charge.
A store has opening hours that may vary from day to day. A
responsible person has a name and an email address. The address of the store is
consists of the address, house number, postal code, town and country.
Each order is made up of the identifier of the customer who placed it, the status
order, a list of sandwiches and their respective quantities, as well as the day of
delivery and the specific store where it will be delivered.
total price of the order, it should be taken into account that a sandwich cannot be sold
be sold below zero, despite any promotions applied.
Each customer includes his personal details, such as name, tax identification number
number, address, e-mail address, authentication data, and languages that he or she can speak.
The customer's address consists of the address, house number, zip code
city and country.
System administrator functions include creating, changing and deleting sandwiches, ingredients and stores, adding descriptions, adding ingredients to
to sandwiches, and viewing customer information. The person in charge of the store
has the functionality to look up customer information, check orders, and change order
and change order status. Customer functionalities include viewing customer
information about their customer data, sandwiches, stores, ingredients and their
orders.
The system should respond in less than 3 seconds to 10 simultaneous users, have an authentication and authorization system, be modifiable with respect to introducing new features or changing the order status.
The system should respond in less than 3 seconds to 10 simultaneous users, contain an authentication and authorization system, be modifiable with respect to the introduction of new features or change some existing ones, tests should be adopted in the various dimensions, this includes the business rules
rules captured and the correct operation of the application, a messaging system via a message
a message broker and finally only open source technologies and tools are allowed to be used.
and open source tools.
Since the company will be opening soon, about 3 months, the software must be
available by the opening date.

# Prerequisites

1. Docker
- Install docker in your machine, follow this [link](https://docs.docker.com/engine/install/)
- Create the container with the mysql image

You can create the container with the following code:
```
docker run --name my-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=mypassword -d mysql
```

- Create a user with all the permissions

You can enter your container with the following code:

```
docker exec -it <container-name> bin/bash
mysql -u root -p
```
Insert your password and to create the user insert this code:
```
CREATE USER ‘myUser’@’%’ IDENTIFIED BY ‘myPassword’; 
GRANT ALL PRIVILEGES ON *.* TO 'myUser'@'%';
```

2. Ballerina
- Install Ballerina, the link can be found [here](https://ballerina.io/learn/install-ballerina/set-up-ballerina/)
- Install a text editor like [Visual Studio Code](https://code.visualstudio.com/)
- To install the addon only available on VSC follow this [link](https://marketplace.visualstudio.com/items?itemName=WSO2.ballerina)

You can check if the installation of Ballerina was successful with the following code:

```
bal version or bal
```
> :warning: **Documentation of Ballerina**: [LINK](https://ballerina.io/learn/)

# Open-Source tools and technologies used
- [Ballerina (Programming Language)](https://ballerina.io/)
- [Docker (Container manager)](https://podman.io/)
- [Mysql (Database)](https://www.mysql.com/)
- [Postman (API Client)](https://www.postman.com/)
- [JMeter (Load test tool)](https://jmeter.apache.org/)
- [NodeJS (Framework)](https://nodejs.org/en)
- [Python (Programming Language)](https://www.python.org/)

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

[User Cases](https://github.com/TiagoNora/ballerina-project/blob/1464445bb0ee4a552aed878bb9cdfd032406d621/docs/UserCases.md)


## API Documentation

[API Documentation](https://github.com/TiagoNora/ballerina-project/blob/aadb3b63f9472f75f8c05a05dd9c3e92a8716e4a/docs/ApiDocumentation.md)

## License

[MIT](https://choosealicense.com/licenses/mit/)

