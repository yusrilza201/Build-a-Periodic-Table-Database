#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ $# -eq 0 ]
then
  echo "Please provide an element as an argument."
  exit 0
fi

ARG=$1

ELEMENT_INFO() {
  local QUERY=$1
  ELEMENT_RESULT=$($PSQL "$QUERY")

  if [[ -z $ELEMENT_RESULT ]]; then
    echo "I could not find that element in the database."
    exit 0
  fi
echo $ELEMENT_RESULT | while IFS=" | " read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT; do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

# Check if ARG is a number (atomic number)
if [[ $ARG =~ ^[0-9]+$ ]]; then
  QUERY="SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e FULL JOIN properties AS p USING(atomic_number) FULL JOIN types AS t USING(type_id) WHERE atomic_number=$ARG"
else
  # Check if ARG is a symbol or name
  QUERY="SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e FULL JOIN properties AS p USING(atomic_number) FULL JOIN types AS t USING(type_id) WHERE symbol='$ARG' OR name='$ARG'"
fi

# Get and display element info
ELEMENT_INFO "$QUERY"


