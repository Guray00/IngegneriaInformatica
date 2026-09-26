@echo off
c:\prg\jdk8\bin\javac -classpath c:\prg\libs\xstream-1.4.7.jar *.java
pause

set L=c:\prg\libs\
set LIBS=%L%xstream-1.4.7.jar;%L%xmlpull-1.1.3.1.jar;%L%xpp3_min-1.1.4c.jar;%L%mysql-connector-java-5.1.34-bin.jar;

start cmd /k "color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% Opinionista 8082 8080 50"
start cmd /k "color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% Opinionista 8081 8082 60"
start cmd /k "color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% Opinionista 8080 8081 55 "Altezza della Torre di Pisa" 2"
pause
taskkill /f /im "java.exe"
rem risultato 57.5  calcolato senza il contributo di 8082
pause

start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% Opinionista 8082 8080 50"
start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% Opinionista 8081 8082 60"
start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% Opinionista 8080 8081 55 "Altezza della Torre di Pisa" 3"
pause
taskkill /f /im "java.exe"
rem come risultato 55 calcolato con il contributo di tutti
pause

start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% Opinionista 8082 8080 50"
start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% Opinionista 8081 8082 60"
start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% Opinionista 8080 8081 55 "Altezza della Torre di Pisa" 4"
pause
taskkill /f /im "java.exe"
rem nessun risultato (numero minimo non raggiunto)
pause

start cmd /k "color 5F && c:\prg\jdk8\bin\java -classpath %LIBS% Opinionista 8082 8080 50"
start cmd /k "color 5F && c:\prg\jdk8\bin\java -classpath %LIBS% Opinionista 8081 8082 60"
start cmd /k "color 5F && c:\prg\jdk8\bin\java -classpath %LIBS% Opinionista 8080 8081 55 "Altezza della Torre di Pisa" 1"
pause
taskkill /f /im "java.exe"
rem risultato 55 calcolato con il solo contributo di 8080
pause
