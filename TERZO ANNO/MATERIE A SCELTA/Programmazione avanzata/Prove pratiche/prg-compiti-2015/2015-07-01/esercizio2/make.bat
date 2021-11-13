@echo off
c:\prg\jdk8\bin\javac *.java
pause

start cmd /k "color 2F && c:\prg\jdk8\bin\java Commerciante 8082 8080 30" 
pause
start cmd /k "color 2F && c:\prg\jdk8\bin\java Commerciante 8081 8082 40"
pause
start cmd /k "color 2F && c:\prg\jdk8\bin\java Commerciante 8080 8081 20 10 "Mouse di Alan Turing""
pause
taskkill /f /im "java.exe"
rem come risultato stampa "compratore 8081"
pause

start cmd /k "color 3F && c:\prg\jdk8\bin\java Commerciante 8082 8080 30" 
pause
start cmd /k "color 3F && c:\prg\jdk8\bin\java Commerciante 8081 8082 45"
pause
start cmd /k "color 3F && c:\prg\jdk8\bin\java Commerciante 8080 8081 20 10 "Mouse di Alan Turing""
pause
taskkill /f /im "java.exe"
rem come risultato stampa "compratore 8082"
pause

start cmd /k "color 4F && c:\prg\jdk8\bin\java Commerciante 8082 8080 40" 
pause
start cmd /k "color 4F && c:\prg\jdk8\bin\java Commerciante 8081 8082 40"
pause
start cmd /k "color 4F && c:\prg\jdk8\bin\java Commerciante 8080 8081 20 10 "Mouse di Alan Turing""
pause
taskkill /f /im "java.exe"
rem come risultato stampa "compratore 8081"
pause

start cmd /k "color 5F && c:\prg\jdk8\bin\java Commerciante 8082 8080 20" 
pause
start cmd /k "color 5F && c:\prg\jdk8\bin\java Commerciante 8081 8082 20"
pause
start cmd /k "color 5F && c:\prg\jdk8\bin\java Commerciante 8080 8081 20 10 "Mouse di Alan Turing""
pause
taskkill /f /im "java.exe"
rem come risultato stampa "compratore 8081"
pause