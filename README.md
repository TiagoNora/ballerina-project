
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
- [x]  US09: Add description or descriptions to sandwich
- [x]  US10: Get all sandwiches that doesn´t have a particular ingrendient


## Calendar

| Week | Timeframe    | Description                | Comment|
| :-------- | :------- | :------------------------- | :----|
| 1 | 22/02/2023-01/03/2023 | INICIAL CONFIGURATION | DONE :white_check_mark:     |
|   |                       | US01-US10             |  DONE :white_check_mark:    |
| 2 | 01/03/2023-08/03/2023 | UPLOAD TEMPLATE OF THE BACHELOR PROJECT REPORT IN GITHUB|  DONE :white_check_mark:  |
|   |                       | WRITING THE STATE OF THE ART TO INCLUDE IN THE REPORT (DIFERENTS ARCHITECTURES)| DONE :white_check_mark:   | 
| 3 | 08/03/2023-15/03/2023 | ALTER US05 TO BE ABLE MAKE A REQUEST TO A SERVICE TO VERIFY THE LANGUAGE OF THE TEXT|  IN PROGRESS :construction: |
|   |                       | WRITING ABOUT TECHNOLOGIES TO INCLUDE IN THE REPORT |  IN PROGRESS :construction: |
|   |                       |                     |   |


## API Documentation

[API Documentation](https://github.com/TiagoNora/ballerina-project/blob/fe611e643f987d1098c92e0ae58d614024d34fab/docs/apiDocumentation.md)

## License

[MIT](https://choosealicense.com/licenses/mit/)

