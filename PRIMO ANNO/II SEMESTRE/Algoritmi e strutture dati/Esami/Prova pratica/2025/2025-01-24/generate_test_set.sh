#!/usr/bin/env bash
#
# Usage: ./gen_test.sh N M
#   N = number of teachers
#   M = number of enrollments
#
# Output is printed on stdout in the format:
#   N M
#   <matricola_1> <cognome_1>
#   <matricola_2> <cognome_2>
#   ...
#   <matricola_N> <cognome_N>
#   <matricolaForEnrollment_1> <courseCode_1>
#   <matricolaForEnrollment_2> <courseCode_2>
#   ...
#   <matricolaForEnrollment_M> <courseCode_M>
#

# Read parameters


N=15   # number of teachers

# We keep an array of all teacher IDs so we can pick from them for the enrollments
SOLUTION="$(realpath ./soluzione.cpp)"
TMPDIR=$(mktemp -d)
cd $TMPDIR
g++ -std=c++17 -O3 $SOLUTION -o soluzione
cd -
BIN="$TMPDIR/soluzione"
mkdir TestSet
cd TestSet
for (( i=1; i<=N; i++ ))
do
    A=$(( (RANDOM % 4999) + 1 ))
    B=$(( (RANDOM % 4999) + 1 ))
    echo "$A $B"
    bash ../generate_single_test.sh $A $B > "input$i.txt"
    ../soluzione < "input$i.txt" > "output$i.txt"
done
rm -rf $TMPDIR
cd ..