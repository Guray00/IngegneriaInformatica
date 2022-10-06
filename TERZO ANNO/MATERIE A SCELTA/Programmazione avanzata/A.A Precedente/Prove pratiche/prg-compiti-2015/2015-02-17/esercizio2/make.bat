c:\prg\jdk8\bin\javac *.java
pause
start cmd /k "c:\prg\jdk8\bin\java Commerciante 8082 8080 .15" 
pause
start cmd /k "c:\prg\jdk8\bin\java Commerciante 8081 8082 .81"
pause
start cmd /k "c:\prg\jdk8\bin\java Commerciante 8080 8081 .47"
pause
rem come risultato stampa 0.47666...
