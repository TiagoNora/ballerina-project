import ballerina/file;
import ballerina/io;

listener file:Listener inFolder = new ({
    path: "./words",
    recursive: false
});

string lastPrintedLine = "";

service "localObserver" on inFolder {

    remote function onModify(file:FileEvent m) {
        string filePath = "./words/file.txt";
        string[]|error lines = io:fileReadLines(filePath);
        if lines is string[] {
            string lastLine = lines[lines.length() - 1];
            if (lastLine != lastPrintedLine) {
                io:println("Last line: " + lastLine);
                lastPrintedLine = lastLine;
            }
        }
    }
}