#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

GET_WHERE_CLAUSE() {
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    echo "atomic_number = $1"
  else
    echo "symbol = '$1' OR name = '$1'"
  fi
}

PRINT_ELEMENT() {
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else 
    IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE <<< "$ELEMENT"
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
}

MAIN() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    WHERE_CLAUSE=$(GET_WHERE_CLAUSE "$1")
    ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE $WHERE_CLAUSE")
    PRINT_ELEMENT $ELEMENT
  fi
}

MAIN $1
