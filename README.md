
# Ballerina project

Welcome to my GitHub project! This project is being developed under the curricular unit of PESTA(internship/project). It will demonstrate how to develop applications in ballerina, a programming language that aims to help developers to build easy and fast cloud-native application.

# Prerequisites

1. Podman
- Install podman in your machine, follow this [link](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md)
- Create the container with the mysql image

You can create the container with the following code:
```
podman run --name my-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=mypassword -d mysql
```

- Create a user with all the permissions

You can enter your container and create the user with the following code:

```
podman exec -it <container-name> bin/bash
mysql -u root -p
```
Insert your password
```
CREATE USER ‘myUser’@’%’ IDENTIFIED BY ‘myPassword’; 
GRANT ALL PRIVILEGES ON *.* TO 'myUser'@'%';
```

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

[User Cases](https://github.com/TiagoNora/ballerina-project/blob/1464445bb0ee4a552aed878bb9cdfd032406d621/docs/UserCases.md)


## Calendar

[Calendar](https://github.com/TiagoNora/ballerina-project/blob/1464445bb0ee4a552aed878bb9cdfd032406d621/docs/Calendar.md)


## API Documentation

[API Documentation](https://github.com/TiagoNora/ballerina-project/blob/aadb3b63f9472f75f8c05a05dd9c3e92a8716e4a/docs/ApiDocumentation.md)

## License

[MIT](https://choosealicense.com/licenses/mit/)

