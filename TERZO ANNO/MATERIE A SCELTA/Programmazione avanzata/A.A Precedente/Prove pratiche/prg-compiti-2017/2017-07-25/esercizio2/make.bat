@echo off
c:\prg\jdk8\bin\javac -classpath c:\prg\libs\xstream-1.4.7.jar *.java
pause

set L=c:\prg\libs\
set LIBS=%L%xstream-1.4.7.jar;%L%xmlpull-1.1.3.1.jar;%L%xpp3_min-1.1.4c.jar;%L%mysql-connector-java-5.1.34-bin.jar;

start cmd /k "@echo off && color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8082 8080"
start cmd /k "@echo off && color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8081 8082"
start cmd /k "@echo off && color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8080 8081 create 0"
pause
taskkill /f /im "java.exe"
rem risultato: tutti gli host hanno una lista vuota nel db
pause

start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8082 8080"
start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8081 8082 add 3.14"
start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8080 8081"
pause
taskkill /f /im "java.exe"
rem risultato: lo host 8081 inserisce il dato 3.14
pause

start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8082 8080"
start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8081 8082 add 1.72"
start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8080 8081"
pause
taskkill /f /im "java.exe"
rem risultato: lo host 8082 inserisce il dato 1.72
pause

start cmd /k "color 5F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8082 8080"
start cmd /k "color 5F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8081 8082 add 5.92"
start cmd /k "color 5F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8080 8081"
pause
taskkill /f /im "java.exe"
rem risultato: lo host 8080 inserisce il dato 5.92
pause

start cmd /k "color 6F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8082 8080"
start cmd /k "color 6F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8081 8082 add 2.16"
start cmd /k "color 6F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8080 8081"
pause
taskkill /f /im "java.exe"
rem risultato: lo host 8081 inserisce il dato 2.16
pause

start cmd /k "color 7F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8082 8080"
start cmd /k "color 7F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8081 8082 remove 5.92"
start cmd /k "color 7F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8080 8081"
pause
taskkill /f /im "java.exe"
rem risultato: lo host 8080 rimuove il dato 5.92
pause

start cmd /k "color 8F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8082 8080"
start cmd /k "color 8F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8081 8082 remove 5.9"
start cmd /k "color 8F && c:\prg\jdk8\bin\java -classpath %LIBS% PCList 8080 8081"
pause
taskkill /f /im "java.exe"
rem risultato: nessuno estrae
pause