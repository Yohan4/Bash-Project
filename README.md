# Bash-Project
# CST 1500

#!/bin/bash

function Date
{
zenity --info \
--title "Date and Time" \
--text "TIME: $(date "+%T")    # Displays the time and date in a formatted way using zenity which allows to create graphical dialog boxes

DATE: $(date "+%d-%B-%Y")" \
width 900 \
height 900 \
}


function calendar
{
while true
do
    DATE=$(zenity --calendar --text="select a date to add an event" --ok-label "Add event" --cancel-label "Back" --width=400 --height=100 --title="SELECT A DATE" --date-format='%d.%m.%Y' )
   
   if [ $? -eq 0 ] #$? = was last command succesfull . Answer is 0 means 'yes'. Non-zero values means 'No'
   then 
        FILENAME="$calendar.txt"
        if [ -f "$FILENAME" ] # check if the file exits
        then
            reminder "$DATE" #if true reminder is called and performs what is in the function reminder
        else
            ADD_EVENT=$(zenity --entry --text="Add an event" --width=500 --height=200) # if false it displays an entry box and stores      the user input in variable ADD_EVENT
        fi
   else
        break #exits the loop if cancel button is chosen
   fi
   echo "$ADD_EVENT">>"$FILENAME" #The user input is stored in the file FILENAME="Calendar.txt"
   reminder "$DATE"
done
}


function reminder
{
while true
do
   zenity --text-info \
    --title="REMINDER" \
    --width=200 \
    --height=200 \
    --ok-label="ADD NEW EVENT" \
    --cancel-label="cancel" \
    --editable \
   --filename="remin.txt"
   
   if [ $? -eq 1]
   then
       break
   else
       ADD_EVENT=$(zenity --entry --text="Add an event" --width=500 --height=200)
       echo "$ADD_EVENT">>"$remin.txt"
   fi
done   
}

