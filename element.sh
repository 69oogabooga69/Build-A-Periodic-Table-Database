#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

MAIN() {
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    SEARCH_ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) WHERE atomic_number = $1;")
  else
    if [[ ${#1} -le 2 ]]
    then
      SEARCH_ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) WHERE symbol = '$1';")
    else
      SEARCH_ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) WHERE name = '$1';")
    fi
  fi
  if [[ -z $SEARCH_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$SEARCH_ELEMENT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MPC BPC TYPE_ID
    do
      FORMAT
    done
  fi
}

FORMAT() {
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
}

if [[ $1 ]]
then
  MAIN $1
else
  echo "Please provide an element as an argument."
fi
