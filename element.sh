#!/bin/bash

# Command to connect to PostgreSQL database
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Function to print element information
print_element_info() {
    # Assign function arguments to local variables
    local NUMBER=$1
    local SYMBOL=$2
    local NAME=$3
    local WEIGHT=$4
    local MELTING=$5
    local BOILING=$6
    local TYPE=$7

    # Print formatted element information
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
}

# Function to get element by name
get_element_by_name() {
    local SYMBOL=$1
    # Query database to get element information by name
    local DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE name='$SYMBOL'")
    # Check if data is empty
    if [[ -z $DATA ]]; then
        echo "I could not find that element in the database."
    else
        # Read each line of data and call print_element_info function
        while read BAR BAR NUMBER BAR SYMBOL BAR NAME BAR WEIGHT BAR MELTING BAR BOILING BAR TYPE; do
            print_element_info $NUMBER $SYMBOL $NAME $WEIGHT $MELTING $BOILING $TYPE
        done <<< "$DATA"
    fi
}

# Function to get element by symbol
get_element_by_symbol() {
    local SYMBOL=$1
    # Query database to get element information by symbol
    local DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$SYMBOL'")
    # Check if data is empty
    if [[ -z $DATA ]]; then
        echo "I could not find that element in the database."
    else
        # Read each line of data and call print_element_info function
        while read BAR BAR NUMBER BAR SYMBOL BAR NAME BAR WEIGHT BAR MELTING BAR BOILING BAR TYPE; do
            print_element_info $NUMBER $SYMBOL $NAME $WEIGHT $MELTING $BOILING $TYPE
        done <<< "$DATA"
    fi
}

# Function to get element by atomic number
get_element_by_atomic_number() {
    local SYMBOL=$1
    # Query database to get element information by atomic number
    local DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number=$SYMBOL")
    # Check if data is empty
    if [[ -z $DATA ]]; then
        echo "I could not find that element in the database."
    else
        # Read each line of data and call print_element_info function
        while read BAR BAR NUMBER BAR SYMBOL BAR NAME BAR WEIGHT BAR MELTING BAR BOILING BAR TYPE; do
            print_element_info $NUMBER $SYMBOL $NAME $WEIGHT $MELTING $BOILING $TYPE
        done <<< "$DATA"
    fi
}

# Main function
main() {
    SYMBOL=$1
    # Check if an argument is provided
    if [[ -z $1 ]]; then
        echo "Please provide an element as an argument."
    else
        # Check if the argument is a number or not
        if [[ ! $SYMBOL =~ ^[0-9]+$ ]]; then
            LENGTH=$(echo -n "$SYMBOL" | wc -m)
            # If length of the symbol is greater than 2, get element by name, else get by symbol
            if [[ $LENGTH -gt 2 ]]; then
                get_element_by_name $SYMBOL
            else
                get_element_by_symbol $SYMBOL
            fi
        else
            # If the argument is a number, get element by atomic number
            get_element_by_atomic_number $SYMBOL
        fi
    fi
}

# Call the main function with command-line arguments
main "$@"
