@echo off
c:\prg\jdk8\bin\javac -classpath c:\prg\libs\xstream-1.4.7.jar *.java
pause

set L=c:\prg\libs\
set LIBS=%L%xstream-1.4.7.jar;%L%xmlpull-1.1.3.1.jar;%L%xpp3_min-1.1.4c.jar;

start cmd /k "@echo off && color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8082 8080"
start cmd /k "@echo off && color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8081 8082"
start cmd /k "@echo off && color 2F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8080 8081 crea 0"
pause
taskkill /f /im "java.exe"
rem risultato: tutti gli host creano un file senza dati
type 8080_archivio.xml
type 8081_archivio.xml
type 8082_archivio.xml
pause

start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8082 8080"
start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8081 8082 inserisci 3.14"
start cmd /k "color 3F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8080 8081"
pause
taskkill /f /im "java.exe"
rem risultato: lo host 8081 inserisce il dato 3.14
type 8080_archivio.xml
type 8081_archivio.xml
type 8082_archivio.xml
pause

start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8082 8080"
start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8081 8082 inserisci 1.72"
start cmd /k "color 4F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8080 8081"
pause
taskkill /f /im "java.exe"
rem risultato: lo host 8082 inserisce il dato 1.72
type 8080_archivio.xml
type 8081_archivio.xml
type 8082_archivio.xml
pause

start cmd /k "color 5F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8082 8080"
start cmd /k "color 5F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8081 8082 inserisci 5.92"
start cmd /k "color 5F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8080 8081"
pause
taskkill /f /im "java.exe"
rem risultato: lo host 8080 inserisce il dato 5.92
type 8080_archivio.xml
type 8081_archivio.xml
type 8082_archivio.xml
pause

start cmd /k "color 6F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8082 8080"
start cmd /k "color 6F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8081 8082 inserisci 2.16"
start cmd /k "color 6F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8080 8081"
pause
taskkill /f /im "java.exe"
rem risultato: lo host 8081 inserisce il dato 2.16
type 8080_archivio.xml
type 8081_archivio.xml
type 8082_archivio.xml
pause

start cmd /k "color 7F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8082 8080"
start cmd /k "color 7F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8081 8082 estrai 5.92"
start cmd /k "color 7F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8080 8081"
pause
taskkill /f /im "java.exe"
rem risultato: lo host 8080 rimuove il dato 5.92
type 8080_archivio.xml
type 8081_archivio.xml
type 8082_archivio.xml
pause

start cmd /k "color 8F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8082 8080"
start cmd /k "color 8F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8081 8082 estrai 5.9"
start cmd /k "color 8F && c:\prg\jdk8\bin\java -classpath %LIBS% ArchivioDistribuito 8080 8081"
pause
taskkill /f /im "java.exe"
rem risultato: nessuno estrae
type 8080_archivio.xml
type 8081_archivio.xml
type 8082_archivio.xml
pause