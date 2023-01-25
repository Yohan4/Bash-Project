#!/bin/bash

# The main will display everything in the function utility selector
main() {
    utility_selector 
}

utility_selector() {
    # A list dialog box with all utilities to be selected from will be displayed  and  is stored in variable selected_utility
    # The radiolist enables us to use radio buttons for the first column
    selected_utility=$(
        zenity --list \
            --title="Utility Selector" \
            --radiolist \
            --column="" --column="Utilities" \
            False "Date/Time" \
            False "Calendar" \
            False "Delete" \
            --cancel-label="Exit" \
            --ok-label="Open"
    )
    
    #$? command is used to know if exit(the 1 pattern) or open (the zero patern) has been selected
    case $? in
    0)
        # when one of the utilities has been selected it will call their respective function and perform their task
        case $selected_utility in
        "Date/Time")
            date_time
            ;;
        "Calendar")
            calendar
            ;;
        "Delete")
            delete_menu
            ;;
        # The default operator is used to diplay a warning message using the warning dialog if ever open is clicked and no utilities has been selected yet
        *)
            zenity --warning \
                --text="Please select an item to continue!"
            # returns to main menu after ok is selected
            main
            ;;
        esac
        ;;
    1)
        exit
        ;;
    esac
}

date_time() {
    (
        while true; do
            echo "# Time: $(date "+%T")  |  DATE: $(date "+%d-%B-%Y")"
            echo "100"
        done
    ) |
        zenity --progress \
            --title="Clock" \
            --text="Date/Time" \
            --percentage=0

    case $? in
    0)
        main
        ;;
    1)
        main
        ;;
    esac
}

calendar() {
    while true; do
        # Displays the calendar dialog box and store the date chosen in variable $Date
        Date=$(zenity --calendar --text="select a date to add an event" --ok-label "Add event" --cancel-label "cancel" --width=500 --height=300 --title="SELECT A DATE" --date-format='%d.%m.%Y')

        #$? = was last command succesfull . Answer is 0 means 'yes ok-label has been selected'. Non-zero values means 'No cancel-label has been selected'
        if [ $? -eq 1 ]; then
            main
        fi
        #The file is assigned to variable NAME
        NAME="$Date.txt"
        # check if the file with thay specific date exists
        if [ -f "$NAME" ]; then
            #if true reminder of that specific date is called and performs what is in the function reminder
            Reminder "$Date"
        else
            # if false it displays an entry box and    the user input is stored in variable ADD_EVENT
            ADD_EVENT=$(zenity --entry --title="ADD AN EVENT" --text="Add an event on $Date" --width=500 --height=300)
            #The user input is stored in the file NAME="Date.txt" which is a specific date
            echo "$ADD_EVENT" >>"$NAME"
            Reminder "$Date"
        fi
    done
}

Reminder() {
    while true; do
        zenity --text-info \
            --title="REMINDER for $Date" \
            --width=500 \
            --height=400 \
            --ok-label="Add New Event" \
            --cancel-label="Go Back" \
            --filename="$1.txt" # Displays text information dialog

        #check if cancel label has been selected
        if [ $? -eq 1 ]; then
            #if true exits the loop
            break
        else
            #displays a text entry dialog  and user input is saved in variable ADD_EVENT
            ADD_EVENT=$(zenity --entry --title="NEW EVENT" --text="Add a new event on $Date" --cancel-label="Go Back" --width=500 --height=300)
            #user input is appended in a file
            echo "$ADD_EVENT" >>"$1.txt"
        fi
    done
}

delete_menu() {
    directory_input=$(
        zenity --entry \
            --title="Directory Path" \
            --text="Enter a directory name (Eg. Desktop):" \
            --entry-text="Desktop"
    )

    case $? in
    0)
        if [ "$directory_input" = "" ]; then
            # in case input is empty do
            file_to_delete=$(file_selector $pwd)
            if [ "$file_to_delete" != false ]; then
                delete_file $file_to_delete
            else
                main
            fi

        else
            # in case input is not empty do
            file_to_delete=$(file_selector $HOME\/$directory_input)
            if [ "$file_to_delete" != false ]; then
                delete_file $file_to_delete
            else
                main
            fi

        fi
        ;;
    1)
        # if cancel button is triggered go back to main menu
        main
        ;;
    esac
}

file_selector() {
    directory=$1
    FILE=$(zenity --file-selection --filename="$directory/" --title="Select a File")

    case $? in
    0)
        echo "$FILE"
        ;;
    1)
        echo false
        ;;
    -1)
        zenity --warning \
            --text="Unexpected error has occurred. Please try again!"
        echo false
        ;;
    esac
}

delete_file() {
    full_path=$1
    initial_directory=$pwd
    file_location="${full_path%/*}/"
    file_name=$(basename ${full_path})

    # prompt user a warning and accepts a confirmation, bool value yes or no
    zenity --question \
        --title="Deleting File" \
        --text="You are about to delete file at path: '$full_path'. \n\n Are you sure you wish to proceed?"

    case $? in
    0)
        # if user input is Yes
        cd $file_location
        rm $file_name
        cd $initial_directory
        ;;
    1)
        # if user input is No, go back to delete_menu
        delete_menu
        ;;
    esac
}

# call main function and pass all command line parameters using "$@" as a list
main "$@"
