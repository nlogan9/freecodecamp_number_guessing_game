#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
#RND=$(expr 1 + $RANDOM % 1000)
RND=500
games_played=0
best_game=0

echo "Enter your username:"
read name

if [[ $($PSQL "SELECT name FROM users WHERE name = '$name'") ]]
then
  # add lookup and output
  username=$(echo $($PSQL "SELECT name FROM users WHERE name = '$name'") | sed -E 's/^ *| *$//g')
  ID=$(echo $($PSQL "SELECT user_id FROM users WHERE name = '$name'") | sed -E 's/^ *| *$//g')
  games_played=$(echo $($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id = $ID") | sed -E 's/^ *| *$//g')
  best_game=$(echo $($PSQL "SELECT MIN(guesses) FROM games WHERE user_id = $ID") | sed -E 's/^ *| *$//g')
  echo Welcome back, $username! You have played 1 games, and your best game took 501 guesses.
else
  echo "Welcome, $name! It looks like this is  your first time here."
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
    TRIES=$(( $TRIES - 1 ))
  elif [[ $guess = $RND ]]
  then
    echo "You guessed it in $(($RND + 1)) tries. The secret number was $RND. Nice job!"
    CORRECT=1
    if [[ ! $($PSQL "SELECT name FROM users WHERE name = '$name'") ]]
    then
      INSERT=$($PSQL "INSERT INTO users(name) VALUES('$name')")
    fi
    ID=$($PSQL "SELECT user_id FROM users WHERE name = '$name'")
    WIN=$($PSQL "INSERT INTO games(user_id, guesses, secret, num_games, best) VALUES($ID, $TRIES, $RND, $games_played, $best_game)")
    
  elif [[ $guess > $RND ]]
  then
    echo "It's lower than that, guess again:"
  elif [[ $guess < $RND ]]
  then
    echo "It's higher than that, guess again:"
  fi
  
done