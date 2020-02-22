#! /usr/local/bin/bash

# method to read file
read_file() {
    # Grab the file
    local f="$1"

    # create a hashtable or associative array { line text(string): line number }
    declare -A file_items_array

    # Hold the line number
    local current_line=1
    # go line by line in the file
    while IFS= read -r line; do
        # if the line is not empty
        if [ ! -z "$line" ]; then

            # check if the item exists in our array
            if [ "${file_items_array[$line]+abc}" ]; then
                # if the item/text exists in our array... 
                echo ":: Removing Duplicate: [$line] from file: $f 🧹"
                # ...remove the item
                sed -i '.bak' "${current_line}s/$line/ /" $f
            else
                # Otherwise...
                echo "👉 This is the first appearance of $line in file: $f."
                echo "$line will be marked 🏷"

                #  ...add it to the array
                file_items_array["$line"]=$current_line

            fi

        fi

        # increment current line
        ((current_line = current_line + 1))

        # spacing for clarity
        echo "    "
    done <"$f"
}

# if we received files
if [ $# -gt 0 ]; then

    echo "I will start pruging duplicates in $# files."

    echo "List of arguments:"
    for arg in $@; do
        read_file $arg
    done

else # Tell the user they need to provide this script with a file

    echo "This script needs at least one file to execute."
    echo "Example 👉 \"$0 ./path/file.extention\""

fi
