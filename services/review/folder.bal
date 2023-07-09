import ballerina/file;
import ballerina/io;
import ballerinax/rabbitmq;

listener file:Listener inFolder = new ({
    path: "./words",
    recursive: false
});

string lastPrintedLine = "";
final rabbitmq:Client rabbitmqClient;

service "localObserver" on inFolder {

    remote function onModify(file:FileEvent m) {
        string filePath = "./words/file.txt";
        string[]|error lines = io:fileReadLines(filePath);
        if lines is string[] {
            string lastLine = lines[lines.length() - 1];
            if (lastLine != lastPrintedLine) {
                rabbitmq:Error? e = rabbitmqClient->publishMessage({content: lastLine, routingKey: "strings"});
                if e is rabbitmq:Error{
                   io:println("Error"); 
                }
                lastPrintedLine = lastLine;
            }

        }
    }
}

function init() returns error? {
    rabbitmqClient = check new(rabbitmq:DEFAULT_HOST, rabbitmq:DEFAULT_PORT);
    _ = check rabbitmqClient->exchangeDeclare("string", rabbitmq:FANOUT_EXCHANGE);
    _ = check rabbitmqClient->queueDeclare("strings");
    _ = check rabbitmqClient->queueBind("strings", "string", "routingString");                              
}