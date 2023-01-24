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
                False "Operating System Type" \
                False "Computer CPU Informaiton" \
                False "Memory Information" \
                False "Hard Disk Information" \
                False "File System (Mounted)" \
                --cancel-label="Exit" \
                --ok-label="Open"
    )

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
    *)
        echo -n "None Selected"
        ;;
    esac
}

os_type() {
    os_information=$(cat /etc/os-release)

    zenity --text-info \
        --title="Operating System Type" \
        --ok-label="Go Back" <<<$os_information

    case $? in
    0)
        main
        ;;
    esac
}

cpu_information() {
    cpu_specification=$(lscpu)

    zenity --text-info \
        --title="Computer CPU Information" \
        --ok-label="Go Back" <<<$cpu_specification

    case $? in
    0)
        main
        ;;
    esac
}

memory_info() {
    memory_data=$(cat /proc/meminfo)

    zenity --text-info \
        --title="Memory Information" \
        --ok-label="Go Back" <<<$memory_data

    case $? in
    0)
        main
        ;;
    esac
}

# hdd_info() {
#     # TODO
#     # Find a replacement which doesn't require sudo,
#     # or prompt user to enter password to use the following sudo command
#     # sudo hdparm -I /dev/sda
# }

file_system_type() {
    mount_list=$(mount | grep "^/dev")

    zenity --text-info \
        --title="Mounted File System" \
        --ok-label="Go Back" <<<$mount_list

    case $? in
    0)
        main
        ;;
    esac
}

# call main function and pass all command line parameters using "$@" as a list
main "$@"
