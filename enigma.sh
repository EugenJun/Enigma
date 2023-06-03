#!/usr/bin/env bash

echo "Welcome to the Enigma!"

show_menu() {
	echo -e "\n0. Exit\n1. Create a file\n2. Read a file\n3. Encrypt a file\n4. Decrypt a file\nEnter an option:"
}

create_file() {
	echo "Enter the filename:" && read -r filename
	if [[ "$filename" =~ ^[a-zA-Z.]+$ ]]; then
		echo "Enter a message:" && read -r message
		[[ "$message" =~ ^[A-Z[:space:]]+$ ]] &&
		       	{ echo "$message" > "$filename" &&
			       	echo "The file was created successfully!"; } ||
			       	echo "This is not a valid message!"
	else
		echo "File name can contain letters and dots only!"	       
	fi
	}

read_file() {
	echo "Enter the filename:"
	read -r filename
	[[ ! -e "$filename" ]] &&  echo "File not found!" || { echo "File content:" && cat "$filename"; }
}

to_cipher() {
        echo "Enter the filename:"
        read -r filename
        if [[ ! -e "$filename" ]]; then
		echo "File not found!"
	else
		echo "Enter password:" && read -r password
		output_file="$([[ $1 == "e" ]] && echo "$filename.enc" || echo "${filename%.enc}")"
		openssl enc -aes-256-cbc "-$1" -pbkdf2 -nosalt -in "$filename" -out "$output_file" -pass pass:"$password" &>/dev/null;
		exit_code=$?
		if [[ $exit_code -ne 0 ]]; then echo "Fail"
		else echo "Success" && rm "$filename"
		fi
	fi
}

while true
do
	show_menu
	read -r option
	case $option in
        	0) echo "See you later!" && break ;;
        	1) create_file ;;
        	2) read_file ;;
        	3) to_cipher "e" ;;
        	4) to_cipher "d" ;;
        	*) echo "Invalid option!" ;;
	esac
done
