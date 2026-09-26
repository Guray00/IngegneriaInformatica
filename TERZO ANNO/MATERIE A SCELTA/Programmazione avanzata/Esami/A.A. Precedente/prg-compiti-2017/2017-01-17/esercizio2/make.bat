@echo off
c:\prg\jdk8\bin\javac *.java
pause

start cmd /k "color 5F && c:\prg\jdk8\bin\java Medico 8084 8082 "diagnosi: Draculismo""
pause
start cmd /k "color 5F && c:\prg\jdk8\bin\java Medico 8083 8084 "diagnosi: Draculismo""
pause
start cmd /k "color 5F && c:\prg\jdk8\bin\java Medico 8082 8080 8083"
pause
start cmd /k "color 5F && c:\prg\jdk8\bin\java Medico 8081 8082"
pause
start cmd /k "color 5F && c:\prg\jdk8\bin\java Medico 8080 8081 "sintomi: Canini lunghi""
pause
taskkill /f /im "java.exe"
rem come risultato la diagnosi è fatta da Host3
pause

start cmd /k "color 2F && c:\prg\jdk8\bin\java Medico 8084 8082"
pause
start cmd /k "color 2F && c:\prg\jdk8\bin\java Medico 8083 8084 "diagnosi: Draculismo""
pause
start cmd /k "color 2F && c:\prg\jdk8\bin\java Medico 8082 8080 "diagnosi: Draculismo""
pause
start cmd /k "color 2F && c:\prg\jdk8\bin\java Medico 8081 8082"
pause
start cmd /k "color 2F && c:\prg\jdk8\bin\java Medico 8080 8081 "sintomi: Canini lunghi""
pause
taskkill /f /im "java.exe"
rem come risultato la diagnosi è fatta da Host2
pause

start cmd /k "color 4F && c:\prg\jdk8\bin\java Medico 8084 8082"
pause
start cmd /k "color 4F && c:\prg\jdk8\bin\java Medico 8083 8084 "
pause
start cmd /k "color 4F && c:\prg\jdk8\bin\java Medico 8082 8080 "diagnosi: Draculismo""
pause
start cmd /k "color 4F && c:\prg\jdk8\bin\java Medico 8081 8082 "diagnosi: Draculismo""
pause
start cmd /k "color 4F && c:\prg\jdk8\bin\java Medico 8080 8081 "sintomi: Canini lunghi""
pause
taskkill /f /im "java.exe"
rem come risultato la diagnosi è fatta da Host1
pause
