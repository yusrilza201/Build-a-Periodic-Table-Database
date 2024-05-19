#!/bin/bash

PSQL=PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ -z "$1" ]
then
  echo "Please provide an element as an argument."
  exit 1
fi

ARG=$1


