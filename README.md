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


function
{
# $? = was last command succesfull . Answer is 0 means 'yes'. Answer is 1 means 'No'
while true
do
   DATE=$(zenity --calendar --title="SELECT DATE" --text="select a date to add an event" --ok-label="Add event" --width=500 --height=500        --cancel-label="Cancel" --date-format='%m-%d-%y')

   if  [ $? -eq 1 ] 
   then
        break
   else
   ADD_EVENT=$(zenity --entry --text="Add an event" --width=600 --height=200)
   fi
done
}


