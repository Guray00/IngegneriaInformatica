@echo off
c:\prg\jdk8\bin\javac -classpath c:\prg\libs\xstream-1.4.7.jar *.java
pause
set L=c:\prg\libs\
set LIBS=%L%xstream-1.4.7.jar;%L%xmlpull-1.1.3.1.jar;%L%xpp3_min-1.1.4c.jar;%L%mysql-connector-java-5.1.34-bin.jar;

start cmd /k "color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 10.4 8084 8082"
start cmd /k "color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 10.0 8083 8084"
start cmd /k "color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 10.2 8082 8080 8083"
start cmd /k "color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 10.3 8081 8082"
start cmd /k "color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 10.2 8080 8081"
pause
taskkill /f /im "java.exe"
rem campioni stabili a media 10.0 su Host1
pause

start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 15.4 8084 8082"
start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 11.0 8083 8084"
start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 17.8 8082 8080 8083"
start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 19.3 8081 8082"
start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 7.5 8080 8081"
pause
taskkill /f /im "java.exe"
rem campioni stabili a media 14.0 su Host4
pause

start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 30.4 8084 8082"
start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 50.0 8083 8084"
start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 17.8 8082 8080 8083"
start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 19.3 8081 8082"
start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% Terminale 7.5 8080 8081"
pause
taskkill /f /im "java.exe"
rem i campioni a media 25.0 su Host0, ma non stabili
pause