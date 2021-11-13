@echo off
c:\prg\jdk8\bin\javac -classpath c:\prg\libs\xstream-1.4.7.jar *.java
pause
set L=c:\prg\libs\
set LIBS=%L%xstream-1.4.7.jar;%L%xmlpull-1.1.3.1.jar;%L%xpp3_min-1.1.4c.jar;%L%mysql-connector-java-5.1.34-bin.jar;

start cmd /k "color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% AgenziaDelLavoro 8082 8080" 
start cmd /k "color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% AgenziaDelLavoro 8081 8082"
start cmd /k "color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% AgenziaDelLavoro 8080 8081 "Programmatore C?""
rem competenza non disponibile, due giri completi di protocollo
pause

start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% AgenziaDelLavoro 8082 8080" 
start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% AgenziaDelLavoro 8081 8082 "Programmatore C!""
start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% AgenziaDelLavoro 8080 8081 "Programmatore C?""
rem competenza disponibile in Agenzia1, al primo giro Agenzia2 non viene interpellata
pause

start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% AgenziaDelLavoro 8082 8080 "Programmatore C!"" 
start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% AgenziaDelLavoro 8081 8082"
start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% AgenziaDelLavoro 8080 8081 "Programmatore C?""
rem competenza disponibile in Agenzia2, due giri completi di protocollo
pause