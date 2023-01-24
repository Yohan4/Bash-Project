#!/bin/bash

main() {
    utility_selector
}

utility_selector() {
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

    case $selected_utility in
    "Date/Time")
        date_time
        ;;
    "Calendar")
        echo -n "Calendar"
        ;;
    "Delete")
        delete_menu
        ;;
    *)
        echo -n "None Selected"
        ;;
    esac
}

date_time() {
    (
        while true
        do
            echo "# Time: $(date "+%T")  |  DATE: $(date "+%d-%B-%Y")" ;
            echo "100" ;
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

delete_menu() {
    directory_input=$(
        zenity --entry \
                --title="Directory Path" \
                --text="Enter a directory name (Eg. Desktop):" \
                --entry-text="Desktop"
    );

    case $? in
    0)
        if [ "$directory_input" = "" ]; then
            # in case input is empty do
            file_to_delete=$(file_selector $pwd)
            delete_file $file_to_delete

        else
            # in case input is not empty do
            file_to_delete=$(file_selector $HOME\/$directory_input)
            delete_file $file_to_delete

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
    FILE=`zenity --file-selection --filename="$directory/" --title="Select a File"`

    case $? in
        0)
            echo "$FILE"
            ;;
        1)
            echo "No file selected." # TODO : Prompt User Warning and Go Back to delete_file()
            ;;
        -1)
            echo "An unexpected error has occurred." # TODO : Prompt User about the error and go back to main menu
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
            # if user input is No
            echo false # TODO : case false return to file_selector
            ;;
    esac
}

# call main function and pass all command line parameters using "$@" as a list
main "$@"
