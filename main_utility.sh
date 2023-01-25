#!/bin/bash
#
# Module Name : CST1500 Computer Systems Architecture and Operating Systems
# Lecturer : Dr. Visham Ramsurrun
# Teaching Assistant: Karel Veerabudren 
# Project Title : Operating Systems Programming | Coursework 2
#
# Project Scope:
#   This project consists of a list of utilities which can be -
#   use to get information of the systems,
#   and manage file systems
#
# Authors:
#   Developer One:
#       Name: Akilesh Venkata Subhadu
#       Email: AS3874@live.mdx.ac.uk
#       Student No: M00851681
#
#   Developer Two:
#       Name: Sandyl Nursigadoo
#       Email: SN1137@live.mdx.ac.uk
#       Student No: M00851538
#
# Project Files: (main_utility.sh, sub_utility.sh)
# Current File: main_utility.sh
# This project can be extended to open the sub_utility.sh script
# - However both scripts should be in the same directory
# - The part to call the second script has been commented out
#
# How to run?
# Step 1: sudo chmod u+x main_utility.sh ('Enter your password')
# Step 2: ./main_utility.sh


#### FUNCTION BEGIN
# main function which is initiated when the script is launched
# ARGUMENTS: 
# 	"$@", provides a list of command line parameters
#### FUNCTION END
main() {
    # call utility selector menu
    utility_selector 
}

# starts utility menu procedure and opens a dialog with list of menu-items
utility_selector() {
    # A list dialog box with all utilities to be selected from will be displayed and is stored in variable selected_utility
    # The radiolist enables us to use radio buttons for the first column
    selected_utility=$(
        zenity --list \
            --title="Utility Selector" \
            --width=400 \
            --height=200 \
            --radiolist \
            --column="" --column="Utilities" \
            False "Date/Time" \
            False "Calendar" \
            False "Delete" \
            # False "More Utilities" \
            --cancel-label="Exit" \
            --ok-label="Open"
    )
    
    # $? command is used to know if exit(the 1 pattern) or open (the zero patern) has been selected
    # 0) ok button has been pressed
    # 1) exit button has been pressed
    case $? in # CASE STATEMENT BEGIN
    0)
        # when one of the utilities has been selected it will call their respective function and perform their task
        case $selected_utility in # CASE STATEMENT BEGIN
        "Date/Time")
            date_time # call dates function
            ;;
        "Calendar")
            calendar # call calendar function
            ;;
        "Delete")
            delete_menu # call delete file function
            ;;
        # "More Utilities")
        #     ./sub_utility.sh
        #     ;;
        # The default operator is used to diplay a warning message using the warning dialog if ever open is clicked and no utilities has been selected yet
        *)
            # generate a warning to prompt user to select an item
            zenity --warning \
                --text="Please select an item to continue!"
            # returns to main menu after ok is selected
            main # restart through main function
            ;;
        esac # CASE STATEMENT END
        ;;
    1)
        # exit and terminate process id Exit button is pressed
        exit
        ;;
    esac # CASE STATEMENT END
}

#### FUNCTION BEGIN
# starts the date/time procedure and display a dialog with the date and time
#### FUNCTION END
date_time() {
    (
        # keeps updating Date and Time until the the process is terminated
        while true; do
            # output time and date to feed to progree dialog
            echo "# Time: $(date "+%T")  |  DATE: $(date "+%d-%B-%Y")"
            # percentage set to progress dialog, to allow termination of process
            echo "100"
        done
    ) | # '|' pipe allows transfer of stdout to zenity dialog as destination
        # generates a progress dialog with time and date feeded from above
        zenity --progress \
            --title="Clock" \
            --text="Date/Time" \
            --percentage=0

    # case statement to check for stout, '$?' is the output from warning interface
    # 0) user selected ok, go back to main menu
    # 1) user selected cancel, go back to main menu
    case $? in # CASE STATEMENT BEGIN
    0)
        main # go back to main menu
        ;;
    1)
        main # go back to main menu
        ;;
    esac # CASE STATEMENT EMD
}

#### FUNCTION BEGIN
# starts the calendar procedure and display calendar menu
#### FUNCTION END
calendar() {
    # Displays the calendar dialog box and store the date chosen in variable $Date
    Date=$(
        zenity --calendar \
            --title="Calendar/Reminder" \
            --text="Select a date to add a reminder" \
            --date-format='%d.%m.%Y' \
            --cancel-label "Go Back" \
            --ok-label "Open Reminder" \
            --width=500 \
            --height=300 
    )

    #$? = was last command succesfull . Answer is 0 means 'yes ok-label has been selected'. Non-zero values means 'No cancel-label has been selected'
    if [ $? -eq 1 ]; then
        # returns back to main menu when cancel
        main
    fi
    #The file is assigned to variable NAME
    NAME="$Date.txt"
    # check if the file with that specific date exists
    if [ -f "$NAME" ]; then
        #if true reminder of that specific date is called and performs what is in the function reminder
        reminder "$Date"
    else
        # if false it displays an entry box and    the user input is stored in variable ADD_EVENT
        ADD_EVENT=$(zenity --entry \
                           --title="ADD AN EVENT" \
                           --text="Add an event on $Date" \
                           --width=500 \
                           --height=300)
        #The user input is stored in the file NAME="Date.txt" which is a specific date
        echo "$ADD_EVENT" >>"$NAME"
        reminder "$Date"
    fi

}

#### FUNCTION BEGIN
# Starts reminder procedure
# ARGUMENTS: 
# 	Date
# OUTPUT: 
# 	Go back to calendar
#   Add even to a text file to the current directory
#### FUNCTION END
reminder() {
    date=$1 # set functions argument to a date variable

    # generate a dialog which displays reminder panel and current reminders
    zenity --text-info \
        --title="$Date | Reminders" \
        --width=500 \
        --height=400 \
        --ok-label="Add Reminder" \
        --cancel-label="Go Back" \
        --filename="$date.txt" # open file if it exists else display a blank page

    #check if cancel label has been selected
    if [ $? -eq 1 ]; then
        calendar # go back to calendar window
    else
        #displays a text entry dialog, where user can input a reminder, which is inturn stored in variable ADD_EVENT
        ADD_EVENT=$(
            zenity --entry \
                --title="New Reminder" \
                --text="Add a new reminder for: $Date" \
                --cancel-label="Go Back" \
                --width=500 \
                --height=300
        )

        # checks if the returned value is empty and user haven't input a reminder
        # warn user if entry was blank
        # else add a reminder to file
        if [ "$ADD_EVENT" = "" ] ; then
            # generate a warning prompt to notify user about the error
            zenity --warning \
                --text="No reminder has been added!"

            reminder $date # go back to reminder list
        
        else 
            # user input is appended in a file with name as the actual date
            # command automatically creates the file if it doesn't exist
            echo "$ADD_EVENT" >>"$date.txt"

            reminder $date # go back to reminder list
        fi
    fi
}

#### FUNCTION BEGIN
# Executes the delete menu function
# OUTPUT: 
# 	Go back to main menu
#### FUNCTION END
delete_menu() {
    # generate an input box, to ask user for a directory name
    # the output of the user is stored in variable directory_input
    directory_input=$(
        zenity --entry \
            --title="Directory Path" \
            --text="Enter a directory name (Eg. Desktop):" \
            --entry-text="Desktop" # set a default value in the input box
    )

    # case statement to check for stout, '$?' is the output from warning interface
    # 0) user selected ok, move forward
    # 1) user selected cancel, go back to main menu
    case $? in # CASE STATEMENT BEGIN
    0)
        # check if user has entered a value for directory_input
        # if user input is empty, provides current directory as path
        # else use the provided directory name from user input
        if [ "$directory_input" = "" ]; then # if statement to check condition wether user input is empty
            # call function file_selector and parse argument '$pwd' - current directory to the function
            # store returned values in file_to_delete
            # return file path or false for error
            file_to_delete=$(file_selector $pwd)

            # check if a file was returned to delete
            # else go back to main menu
            if [ "$file_to_delete" != false ]; then # if statement to check condition if their was an error thrown
                # call delete function and parse the complete file path, 
                # including filename and suffix to delete as an argument
                delete_file $file_to_delete
            else
                main # go back to main menu
            fi

        else # if user input is not empty
            # call function file_selector and parse argument '$HOME\/$directory_input' - home directory + user selected directory
            # store returned values in file_to_delete
            # return file path or false for error
            file_to_delete=$(file_selector $HOME\/$directory_input)
            if [ "$file_to_delete" != false ]; then # if statement to check condition if their was an error thrown
                # call delete function and parse the complete file path, 
                # including filename and suffix to delete as an argument
                delete_file $file_to_delete
            else
                main # go back to main menu
            fi
        fi
        ;;
    1) 
        # if cancel button is triggered go back to main menu
        main
        ;;
    esac # CASE STATEMENT END
}

#### FUNCTION BEGIN
# Prompt a file selection dialog
# ARGUMENTS: 
# 	Directory_PATH
# RETURN: 
# 	Filepath if a file was selected, 
#   false if no file has been selected,
#   false if an error occured
#### FUNCTION END
file_selector() {
    directory=$1 # set functions argument to a directory variable

    # generate a file selector dialog
    # --filename="$directory", parse the provided directory path to open as default location
    # FILE, save the file path if sucess and selected
    FILE=$(zenity --file-selection --filename="$directory/" --title="Select a File")

    # case statement to check for stout, '$?' is the output from interface
    # 0) a file has been succesfully selected
    # 1) no file has been selected, cancel button trigged
    # -1) unexpected error thrown during execution
    case $? in # CASE STATEMENT BEGIN
    0)
        # return the full filepath, including filename and suffix
        echo "$FILE"
        ;;
    1)
        # return a boolean false, to throw an error
        echo false
        ;;
    -1)
        # generate a warning prompt to notify user about the error
        zenity --warning \
            --text="Unexpected error has occurred. Please try again!"
        # return a boolean false, to throw an error    
        echo false
        ;;
    esac # CASE STATEMENT END
}

#### FUNCTION BEGIN
# Delete a file
# ARGUMENTS: 
# 	File_PATH, including filename and suffix
# OUTPUT: 
# 	Delete selected file, go back to delete_menu
#### FUNCTION END
delete_file() {
    full_path=$1 # set functions argument to a full_path variable
    # get the currently directory, from which the program was launched and sets it to initial_directory variable
    initial_directory=$pwd 
    # strips the location path to the file from the full_path and set it to variable file_location
    file_location="${full_path%/*}/" # '%/*' takes all values before last character '/'
    # strips the file_name with suffix from the full_path and set it to variable file_name
    file_name=$(basename ${full_path}) # 'basename' returns filename with suffix

    # prompt user a warning dialog and accepts a confirmation, boolean value yes or no
    zenity --question \
        --title="Deleting File" \
        --text="You are about to delete file at path: '$full_path'. \n\n Are you sure you wish to proceed?"

    # case statement to check for stout, '$?' is the output from warning interface
    # 0) user selected Yes, agreed to delete
    # 1) user selected No, cancel delete process
    case $? in # CASE STATEMENT BEGIN
    0)
        # change current directory to the file location directory
        cd $file_location
        # delete the file using 'rm' command followed by the filename with suffix
        rm $file_name
        # get back to the initial directory from which the program was initially launched
        cd $initial_directory
        ;;
    1)
        # if user input is No, go back to delete_menu
        delete_menu
        ;;
    esac # CASE STATEMENT END
}

# call main function and pass all command line parameters using "$@" as a list
main "$@"
