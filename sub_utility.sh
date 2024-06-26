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
# Current File: sub_utility.sh
#
# How to run?
# Step 1: sudo chmod u+x sub_utility.sh ('Enter your password')
# Step 2: ./sub_utility.sh


#### FUNCTION BEGIN
# main function which is initiated when the script is launched
# ARGUMENTS: 
# 	"$@", provides a list of command line parameters
#### FUNCTION END
main() {
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
            --height=300 \
            --radiolist \
            --column="" --column="Utilities" \
            False "Operating System Type" \
            False "Computer CPU Informaiton" \
            False "Memory Information" \
            False "Hard Disk Information" \
            False "File System (Mounted)" \
            --cancel-label="Exit" \
            --ok-label="Open"
    )

    # $? command is used to know if exit(the 1 pattern) or open (the zero patern) has been selected
    # 0) ok button has been pressed
    # 1) exit button has been pressed
    case $? in # CASE STATEMENT BEGIN
    0)
        case $selected_utility in # CASE STATEMENT BEGIN
        "Operating System Type")
            os_type # call os type function
            ;;
        "Computer CPU Informaiton")
            cpu_information # call cpu function
            ;;
        "Memory Information")
            memory_info # call memory info function
            ;;
        "Hard Disk Information")
            hdd_info # call hdd info function
            ;;
        "File System (Mounted)")
            file_system_type # call file system type function
            ;;
        # The default operator will display none selected on a newline when open/exit is clicked when no utilities has been selected
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
# executes the os type function and output os informations on a dialog info box
#### FUNCTION END
os_type() { 
    # The command cat /etc/os-release which enables us to check the operating system is stored in  variable os_information
    os_information=$(cat /etc/os-release)  
    
    # The operating system information is displayed using the info dialog box of zenity
    # zenity reads the contents from stdin 
    # <<<stdin- allows zenity to read the content of the variable os_information from stdin
    zenity --text-info \
        --title="Operating System" <<<$os_information
   
   # returns back to main menu when ok-label is selected
    case $? in
    0)
        main
        ;;
    esac
}

#### FUNCTION BEGIN
# executes cpu information function and display cpu information on a dialog info box
#### FUNCTION END
cpu_information() {
    #The command lscpu which displays the cpu details is stored in variable cpu_specification
    cpu_specification=$(lscpu)
    
    #Computer cpu information is displayed using the info dialog box of zenity
    # zenity reads the contents from stdin 
    # <<<stdin- allows zenity to read the content of the variable cpu_information from stdin
    zenity --text-info \
        --title="Computer CPU Information" \
        --ok-label="Go Back" <<<$cpu_specification

    # returns back to main menu when ok-label is selected
    case $? in
    0)
        main
        ;;
    esac
}

#### FUNCTION BEGIN
# executes memory info function and display memory information on a dialog info box
#### FUNCTION END
memory_info() {
    #The command cat /proc/meminfo reports the amount of available and used memory and is stored in variable memory_data
    memory_data=$(cat /proc/meminfo)
    
    #Memory information is displayed using the text dialog box of zenity
    # <<<($data) , allows zenity to read the content of the variable memory_data from stdin
    zenity --text-info \
        --title="Memory Information" \
        --width="400" \
        --height="600" \
        --ok-label="Go Back" <<<$memory_data

    # returns back to main menu when ok-label is selected
    case $? in
    0)
        main
        ;;
    esac
}

#### FUNCTION BEGIN
# executes hdd info function, requires password to get information and display hdd information on a dialog info box
#### FUNCTION END
hdd_info() {
    # generate passowrd dialog for zenity  ans ask user's password
    PASSWORD=$(zenity --password --title="Authentication")

    case $? in
    0)
        if [ "$PASSWORD" = "" ]; then
            # generate a warning prompt to notify user about the error
            zenity --warning \
                --text="Invalid Password!"
            hdd_info # run again
        else
            #lshw extracts detailed information on the hardware configuration of the machine 
            DATA=$(
                (echo -e $PASSWORD) | sudo -S lshw -class storage -class disk
            )

            if [ "$DATA" = "" ]; then
                # generate a warning prompt to notify user about the error
                zenity --warning \
                    --text="Invalid Password!"
                hdd_info # run again
            else
                # generates a window with hard disk information
                zenity --text-info \
                --width="400" \
                --height="600" \
                --title "Hard Drive" <<<$DATA

                case $? in
                *)  #Default operator returns back to main menu
                    main
                    ;;
                esac
            fi
        fi
        ;;
    1) 
        
        main
        ;;
    *)  
        echo "An unexpected error has occurred."
        ;;
    esac
}

#### FUNCTION BEGIN
# executes file system type function and display mounted file systems on a dialog info box
#### FUNCTION END
file_system_type() {
    # The mount statement provide all the mounted devices along with the filesystem format and mounted location in Linux.
    # To get the mounted filesystems type,
    # we will write first the mount keyword along with grep so that we can only get those mounted files that we want to display.
    # This is why we have provided the ^/dev path.*/
    # The command is then stored in variable mount_list
    mount_list=$(mount | grep "^/dev")
    
    # <<<stdin- allows zenity to read the content of the variable mount_list from stdin
    zenity --text-info \
        --title="Mounted File System" \
        --width="400" \
        --height="300" \
        --ok-label="Go Back" <<<$mount_list
    
    case $? in
    *)
        main
        ;;
    esac
 }

# call main function and pass all command line parameters using "$@" as a list
main "$@"
