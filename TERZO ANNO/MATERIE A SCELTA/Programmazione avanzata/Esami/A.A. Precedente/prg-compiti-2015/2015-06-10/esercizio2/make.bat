c:\prg\jdk8\bin\javac *.java
pause
start cmd /k "c:\prg\jdk8\bin\java Votante 8082 8080 SI" 
pause
start cmd /k "c:\prg\jdk8\bin\java Votante 8081 8082 NO"
pause
start cmd /k "c:\prg\jdk8\bin\java Votante 8080 8081 SI "Propongo di introdurre gli OGM""
pause
rem come risultato stampa "accettata"
pause
start cmd /k "c:\prg\jdk8\bin\java Votante 8082 8080 NO" 
pause
start cmd /k "c:\prg\jdk8\bin\java Votante 8081 8082 NO"
pause
start cmd /k "c:\prg\jdk8\bin\java Votante 8080 8081 SI "Propongo di abolire il limite di velocita""
pause
rem come risultato stampa "rifiutata"
pause
start cmd /k "c:\prg\jdk8\bin\java Votante 8082 8080 NI" 
pause
start cmd /k "c:\prg\jdk8\bin\java Votante 8081 8082 NO"
pause
start cmd /k "c:\prg\jdk8\bin\java Votante 8080 8081 SI "Propongo di introdurre l'eutanasia""
pause
rem come risultato stampa "ingiudicata"