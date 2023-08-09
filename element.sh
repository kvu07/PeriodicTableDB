#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
# require an argument
then
  echo Please provide an element as an argument.

else
  # get atomic number using atomic number, symbol, or name
  case $1 in
    [0-9]*) ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1");;
    [A-Z][a-z]|[A-Z]) ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'");;
    *) ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE lower(name)=lower('$1')");;
  esac

  if [[ -z $ATOMIC_NUMBER ]]
  # not in database
  then
    echo I could not find that element in the database.
  
  else
    # query the element information
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_PT_C=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_PT_C=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    
    # output the result
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_PT_C celsius and a boiling point of $BOILING_PT_C celsius."
  fi
fi
