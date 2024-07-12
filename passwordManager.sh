#!/bin/bash

ENCRYPTION_LOCATION="passwords.enc"

# Might've taken inspiration from ChatGPT for the openssl syntax :)
encrypt_string() {
    # Encodes the string using AES-256-CBC encryption. Pipes the output to /dev/null to suppress the warning message.
    echo "$1" | openssl enc -aes-256-cbc -a -salt -pbkdf2 2>/dev/null
}
decrypt_string() {
    # Decodes the string using AES-256-CBC decryption. Pipes the output to /dev/null to suppress the warning message.
    echo "$1" | openssl enc -d -aes-256-cbc -a -salt -pbkdf2 -pass pass:"$2" 2>/dev/null
}

add_password() {
    read -rp "Dienst/Webseite Name eingeben:
 >> " service
    read -rp "Benutzername/Email eingeben:
 >> " username
    read -rp "Passwort eingeben:
 >> " -s password; 
    echo "
    "

    # Encrypts the password before storing it
    encrypted_password=$(encrypt_string "$password") 
    echo "$service,$username,$encrypted_password" >> "$ENCRYPTION_LOCATION"
    echo -e "
    \e[32mPasswort hinzugefügt!\e[0m
    "
}

list_passwords() {
    read -rsp "Dekodierung Passwort eingeben:
 >> " decryption_password
    echo ""

    echo "Gespeicherte Passwörter:
    "

    # Reads the encrypted passwords line by line, decrypts them, and prints the details
    while IFS=',' read -r service username encrypted_password; 
    do
        password=$(decrypt_string "$encrypted_password" "$decryption_password")
        echo "Dienst: $service, Benutzername: $username, Passwort: $password"
    done < "$ENCRYPTION_LOCATION"
}

# Help function
show_help() {
  echo "Benutzung: 

    "1" eingeben um ein Passwort zu addieren,
    "2" eingeben um die Passwörter anzuzeigen,
    "3" eingeben um abzubrechen.
  "
}

# Main screen with options
while true; do
    echo -e "\e[94mWillkommen zum Passwort Manager!\e[0m
    "
    echo "1. Passwort hinzufügen"
    echo "2. Passwörter anzeigen"
    echo "3. Abbrechen
    "

    read -rp "Gebe deine Wahl ein (Zahl eingeben):     
 >> " choice
    echo ""

    case $choice in
        1) add_password ;;
        2) list_passwords ;;
        3) echo "Bricht ab..."
        break ;;
        -h|--help) show_help ;;
        *) echo -e "\e[31mDas ist keine Option!\e[0m
        " ;;
    esac
done 
