@echo off
c:\prg\jdk8\bin\javac *.java
pause

start cmd /k "color 2F && c:\prg\jdk8\bin\java Sponsor 8082 8080 3.6"
pause
start cmd /k "color 2F && c:\prg\jdk8\bin\java Sponsor 8081 8082 7.2"
pause
start cmd /k "color 2F && c:\prg\jdk8\bin\java Sponsor 8080 8081 5.1 "Tablet solidale" 2 10.0"
pause
taskkill /f /im "java.exe"
rem come risultato il progetto e' attivato senza il contributo di 8082
pause

start cmd /k "color 3F && c:\prg\jdk8\bin\java Sponsor 8082 8080 6.2"
pause
start cmd /k "color 3F && c:\prg\jdk8\bin\java Sponsor 8081 8082 0.0"
pause
start cmd /k "color 3F && c:\prg\jdk8\bin\java Sponsor 8080 8081 5.1 "Tablet solidale" 2 10.0"
pause
taskkill /f /im "java.exe"
rem come risultato il progetto e' attivato senza il contributo di 8081
pause

start cmd /k "color 4F && c:\prg\jdk8\bin\java Sponsor 8082 8080 3.6"
pause
start cmd /k "color 4F && c:\prg\jdk8\bin\java Sponsor 8081 8082 2.8"
pause
start cmd /k "color 4F && c:\prg\jdk8\bin\java Sponsor 8080 8081 5.1 "Tablet solidale" 3 5.0"
pause
taskkill /f /im "java.exe"
rem come risultato il progetto  e' attivato con il contributo di tutti
pause

start cmd /k "color 5F && c:\prg\jdk8\bin\java Sponsor 8082 8080 3.6"
pause
start cmd /k "color 5F && c:\prg\jdk8\bin\java Sponsor 8081 8082 2.8"
pause
start cmd /k "color 5F && c:\prg\jdk8\bin\java Sponsor 8080 8081 5.1 "Tablet solidale" 3 20.0"
pause
taskkill /f /im "java.exe"
rem come risultato il progetto  non e' attivato
pause