#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RND=$(expr 1 + $RANDOM % 1000)

echo "Enter your username:"
read name

if [[ $($PSQL "SELECT name FROM users WHERE name = '$name'") ]]
then
  # add lookup and output
  ID=$($PSQL "SELECT user_id FROM users WHERE name = '$name'")
  GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id = $ID")
  MIN=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id = $ID")
  echo "Welcome back, $name! You have played $GAMES_PLAYED games, and your best game took $MIN guesses."
  exit
else
  echo "Welcome, $name! It looks like this is  your first time here."
  INSERT=$($PSQL "INSERT INTO users(name) VALUES('$name')")
  ID=$($PSQL "SELECT user_id FROM users WHERE name = '$name'")
fi

echo $RND