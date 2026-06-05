#!/bin/bash

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Error: No code file specified."
    echo "Usage: $0 <code_file.cpp>"
    exit 1
fi

# Assign the first argument to CODE_FILE
CODE_FILE=$1

# Try to compile a simple program with clang++ since it is faster to compile
COMPILER=""
if command -v clang++ >/dev/null 2>&1; then
    # Create a temporary file to test C++17 support
    TMP_FILE=$(mktemp /tmp/testcpp17_XXXXXX.cpp)
    echo 'int main(){}' > "$TMP_FILE"
    if clang++ -std=c++17 "$TMP_FILE" -o /tmp/testcpp17_XXXXXX.out >/dev/null 2>&1; then
        COMPILER="clang++"
    fi
    rm -f "$TMP_FILE" /tmp/testcpp17_XXXXXX.out
fi

# If clang++ does not support C++17 or is not found, try using g++
if [ -z "$COMPILER" ] && command -v g++ >/dev/null 2>&1; then
    COMPILER="g++"
fi

# Exit if no suitable compiler is found
if [ -z "$COMPILER" ]; then
    echo "Error: No suitable compiler found or C++17 is not supported."
    exit 1
fi

# create a temporary directory
TMP_DIR=$(mktemp -d /tmp/evaluate_XXXXXX)

# Compile the provided code file with the selected compiler and C++17 standard
if ! $COMPILER -std=c++17 "$CODE_FILE" -o "$TMP_DIR/solution"; then
    exit 1
fi

# Define colors for success and failure
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Iterate over sorted input files
for i in $(ls TestSet/input*.txt | sort -V); do
    # Extract test number
    NUM=$(echo $i | grep -o '[0-9]\+')
    # Run the solution and check the output
    PROG="$TMP_DIR/solution"
    if $PROG <$i | diff - $(echo $NUM | xargs -I {} echo "TestSet/output{}.txt"); then
        echo -e "${GREEN}Test $NUM: OK${NC}"
    else
        echo -e "${RED}Test $NUM: FAIL${NC}"
    fi
done

# Clean up
rm -rf "$TMP_DIR"




