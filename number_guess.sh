#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RND=$(expr 1 + $RANDOM % 1000)

echo "Enter your username:"
read name

if [[ $($PSQL "SELECT name FROM users WHERE name = '$name'") ]]
then
  # add lookup and output
  exit
else
  echo "Welcome, $name! It looks like this is  your first time here."
fi

echo $RND