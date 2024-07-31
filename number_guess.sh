#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RND=$(expr 1 + $RANDOM % 1000)

echo "Enter your username:"
read name

if [[ $($PSQL "SELECT name FROM users WHERE name = '$name'") ]]
then
  # add lookup and output
  NAME=$(echo $($PSQL "SELECT name FROM users WHERE name = '$name'") | sed -E 's/^ *| *$//g')
  ID=$($PSQL "SELECT user_id FROM users WHERE name = '$name'")
  GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id = $ID")
  MIN=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id = $ID")
  echo "Welcome back, $name! You have played $GAMES_PLAYED games, and your best game took $MIN guesses."
else
  echo "Welcome, $name! It looks like this is  your first time here."
  INSERT=$($PSQL "INSERT INTO users(name) VALUES('$name')")
  ID=$($PSQL "SELECT user_id FROM users WHERE name = '$name'")
fi

TRIES=0
CORRECT=0

while [[ $CORRECT = 0 ]]
do
  echo "Guess the secret number between 1 and 1000:"
  read guess
  TRIES=$(( $TRIES + 1 ))

  if [[ ! $guess =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $guess = $RND ]]
  then
    echo "You guessed it in $TRIES tries. The secret number was $RND. Nice job!"
    CORRECT=1
    WIN=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($ID, $TRIES)")
  elif [[ $guess > $RND ]]
  then
    echo "It's lower than that, guess again:"
  elif [[ $guess < $RND ]]
  then
    echo "It's higher than that, guess again:"
  fi
done