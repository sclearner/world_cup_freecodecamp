#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams")"
cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
  then
    # find winner team
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    if [[ -z $WINNER_ID ]]
    then
      # if not found, insert new record
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES ('$winner')")
      if [[ $INSERT_WINNER == "INSERT 0 1" ]]
      then
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
      fi
    fi
    # find opponent team
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    if [[ -z $OPPONENT_ID ]]
    then
      # if not found, insert new record
      INSERT_OPPO=$($PSQL "INSERT INTO teams(name) VALUES ('$opponent')")
      if [[ $INSERT_OPPO == "INSERT 0 1" ]]
      then
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
      fi
    fi
    # add new record
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals)")
  fi
done