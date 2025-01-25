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
if [ $# -lt 2 ]; then
  echo "Usage: $0 N M"
  exit 1
fi

N=$1   # number of teachers
M=$2   # number of enrollments

# Print N and M on the first line
echo "$N $M"

# We keep an array of all teacher IDs so we can pick from them for the enrollments
declare -a TEACHERS

# Generate teacher data
for (( i=1; i<=N; i++ ))
do
  # Random teacher "matricola" between 1 and 9999
  MATRICOLA=$(( (RANDOM % 9999) + 1 ))

  # Generate a random "cognome" of length between 4 and 8
  LEN=$(( (RANDOM % 5) + 4 ))
  # /dev/urandom can produce binary data, so we filter with `tr`
  COGNOME=$(head -c 100 /dev/urandom | tr -dc 'A-Za-z' | head -c $LEN)

  # Print the teacher line
  echo "$MATRICOLA $COGNOME"

  # Keep track of this teacher’s matricola
  TEACHERS+=("$MATRICOLA")
done

# Generate M enrollment lines
for (( i=1; i<=M; i++ ))
do
  # Choose a random teacher from the ones we just created
  TINDEX=$(( RANDOM % N ))
  CHOSEN_MATRICOLA="${TEACHERS[$TINDEX]}"

  # Generate a random course code (1..999) 
  COURSE_CODE=$(( (RANDOM % 999) + 1 ))

  # Print the enrollment line
  echo "$CHOSEN_MATRICOLA $COURSE_CODE"
done

