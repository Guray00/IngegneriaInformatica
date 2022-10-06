@echo off
c:\prg\jdk8\bin\javac *.java
pause

start cmd /k "color 2F && c:\prg\jdk8\bin\java AgenziaDelLavoro 8082 8080" 
pause
start cmd /k "color 2F && c:\prg\jdk8\bin\java AgenziaDelLavoro 8081 8082"
pause
start cmd /k "color 2F && c:\prg\jdk8\bin\java AgenziaDelLavoro 8080 8081 "Programmatore C?""
pause

start cmd /k "color 3F && c:\prg\jdk8\bin\java AgenziaDelLavoro 8082 8080" 
pause
start cmd /k "color 3F && c:\prg\jdk8\bin\java AgenziaDelLavoro 8081 8082 "Programmatore C!""
pause
start cmd /k "color 3F && c:\prg\jdk8\bin\java AgenziaDelLavoro 8080 8081 "Programmatore C?""
pause

start cmd /k "color 4F && c:\prg\jdk8\bin\java AgenziaDelLavoro 8082 8080 "Programmatore C!"" 
pause
start cmd /k "color 4F && c:\prg\jdk8\bin\java AgenziaDelLavoro 8081 8082"
pause
start cmd /k "color 4F && c:\prg\jdk8\bin\java AgenziaDelLavoro 8080 8081 "Programmatore C?""
pause
