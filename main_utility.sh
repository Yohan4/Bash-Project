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
#       Email: AS38@live.mdx.ac.uk
#       Student No: M00851681
#
#   Developer Two:
#       Name: Sandyl Nursigadoo
#       Email: SN1137@live.mdx.ac.uk
#       Student No: M00851538
#
# Project Files: (main_utility.sh, sub_utility.sh)
# Current File: sub_utility.sh


# The main will display everything in the function utility selector
main() {
    utility_selector
}
# A list dialog box with all utilities to be selected from will be displayed  and  is stored in variable selected_utility
# The radiolist enables us to use radio buttons for the first column
utility_selector() {
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
    # when one of the utilities has been selected it will call their respective function and perform their task
    case $selected_utility in
    "Operating System Type")
        os_type
        ;;
    "Computer CPU Informaiton")
        cpu_information
        ;;
    "Memory Information")
        memory_info
        ;;
    "Hard Disk Information")
        hdd_info
        ;;
    "File System (Mounted)")
        file_system_type
        ;;
    # The default operator will display none selected on a newline when open/exit is clicked when no utilities has been selected
    *) 
        echo -n "None Selected"
        ;;
    esac
}

os_type() { 
    # The command cat /etc/os-release which enables us to check the operating system is stored in  variable os_information
    os_information=$(cat /etc/os-release)  
    
    # The operating system information is displayed using the info dialog box of zenity
    zenity --info \                      
        --title="Operating System Type" \
        # zenity reads the contents from stdin 
        # <<<stdin- allows zenity to read the content of the variable os_information from stdin
        --ok-label="Go Back" <<<$os_information
   
   # returns back to main menu when ok-label is selected
    case $? in
    0)
        main
        ;;
    esac
}

cpu_information() {
    #The command lscpu which displays the cpu details is stored in variable cpu_specification
    cpu_specification=$(lscpu)
    
    #Computer cpu information is displayed using the info dialog box of zenity
    zenity --info \
        --title="Computer CPU Information" \
        # zenity reads the contents from stdin 
        # <<<stdin- allows zenity to read the content of the variable cpu_information from stdin
        --ok-label="Go Back" <<<$cpu_specification

    # returns back to main menu when ok-label is selected
    case $? in
    0)
        main
        ;;
    esac
}

memory_info() {
    #The command cat /proc/meminfo reports the amount of available and used memory and is stored in variable memory_data
    memory_data=$(cat /proc/meminfo)
    
    #Memory information is displayed using the text dialog box of zenity
    zenity --text-info \
        --title="Memory Information" \
        # <<<($data) , allows zenity to read the content of the variable memory_data from stdin
        --ok-label="Go Back" <<<$memory_data

    # returns back to main menu when ok-label is selected
    case $? in
    0)
        main
        ;;
    esac
}

hdd_info() {
echo "$(cat /proc/scsi/scsi)" > "hardisk.txt"
echo "$(lshw -class storage -class disk)" >> "hardisk.txt"
zenity --text-info \
   --width=800 \
   --height=800 \
   --title "Hard Drive"
}



file_system_type() {
    #The mount statement provide all the mounted devices along with the filesystem format and mounted location in Linux.
    /*To get the mounted filesystems type,
    we will write first the mount keyword along with grep so that we can only get those mounted files that we want to display.
    This is why we have provided the ^/dev path.*/
    #The command is then stored in variable mount_list
    mount_list=$(mount | grep "^/dev")
    
    zenity --text-info \
        --title="Mounted File System" \
        # <<<stdin- allows zenity to read the content of the variable mount_list from stdin
        --ok-label="Go Back" <<<$mount_list
    # returns back to main menu when ok-label is selected
    case $? in
    0)
        main
        ;;
    esac
 }
# call main function and pass all command line parameters using "$@" as a list
main "$@"
