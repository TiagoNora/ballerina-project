
# Ballerina project

Welcome to my GitHub project! This project is being developed under the curricular unit of PESTA(internship/project). It will demonstrate how to develop applications in ballerina, a programming language that aims to help developers to build easy and fast cloud-native application.

# Prerequisites

1. Docker
- Install docker windows in your machine
- Create the container with the mysql image
- Create a user with all the permissions

2. Ballerina
- Install Ballerina 2201.0.0 (Swan Lake) or greater, the link can be found [here](https://ballerina.io/learn/install-ballerina/set-up-ballerina/)
- Install a text editor like [Visual Studio Code](https://code.visualstudio.com/)

You can check if the installation of Ballerina was successful with the following code:

```
bal version or bal
```


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

- [x]  US01: Create ingrendient
- [x]  US02: Get ingrendient by id
- [x]  US03: Get ingrendient by designation
- [x]  US04: Get all ingrendients
- [x]  US05: Create sandwich
- [x]  US06: Get sandwich by id
- [x]  US07: Get all sandwiches
- [ ]  US08: Add ingrendient or ingrendients to sandwich
- [ ]  US09: Add description or descriptions to sandwich
- [ ]  US10: Get all sandwiches that doesn´t have a particular ingrendient



## API Documentation :construction:



## License

[MIT](https://choosealicense.com/licenses/mit/)

