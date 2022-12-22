# Bash-Project
# CST 1500

#!/bin/bash

function Date
{
zenity --info \
--title ""Date and Time" \
--text "TIME: $(date "+%T")                 # Displays the time and date in a formatted way using zenity which allows to create graphical dialog boxes
DATE: $(date "+%d-%B-%Y")" \
width 900 \
height 900 \
}


