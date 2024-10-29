#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ $1 ]]; then
  # Check if the argument is an atomic number (numeric)
  if [[ $1 =~ ^[0-9]+$ ]]; then
    ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1")
  # Check if the argument is a single character (symbol) or a full name (non-numeric)
  else
    ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE symbol = '$1' OR name ILIKE '$1'")
  fi

  # Check if ELEMENT variable has data
  if [[ -z $ELEMENT ]]; then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MPC BPC SY NAME TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SY). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi
