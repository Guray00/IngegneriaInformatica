#!/bin/bash


echo "--------------------------------------------------------------"
echo "EsportaDB.sh"

echo -e "\n\n"
read -p "Inserire il nome del database da esportare:" NOME_DB

echo "esportazione del database ${NOME_DB} in corso..."
echo "premere il tasto invio alla richiesta della password di root"
mysqldump -u root -p ${NOME_DB} > tmp.sql

echo "-- Progettazione Web" >  ${NOME_DB}.sql
echo "DROP DATABASE if exists ${NOME_DB};" >>  ${NOME_DB}.sql
echo "CREATE DATABASE  ${NOME_DB};" >>  ${NOME_DB}.sql
echo "USE  ${NOME_DB};" >>  ${NOME_DB}.sql
cat tmp.sql >>  ${NOME_DB}.sql
rm tmp.sql

echo "...esportazione terminata."
echo "--------------------------------------------------------------"

