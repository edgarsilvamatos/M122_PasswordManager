#!/bin/bash

ENCRYPTION_LOCATION="passwords.enc"

# Might've taken inspiration from ChatGPT for the openssl syntax :)
encrypt_string() {
    echo "$1" | openssl enc -aes-256-cbc -a -salt -pbkdf2 2>/dev/null
}
decrypt_string() {
    echo "$1" | openssl enc -d -aes-256-cbc -a -salt -pbkdf2 -pass pass:"$2" 2>/dev/null
}

add_password() {
    read -p "Dienst/Webseite Name eingeben:
 >> " service
    read -p "Benutzername/Email eingeben:
 >> " username
    read -p "Passwort eingeben:
 >> " -s password; 
    echo "
    "

    encrypted_password=$(encrypt_string "$password") 
    echo "$service,$username,$encrypted_password" >> "$ENCRYPTION_LOCATION"
    echo -e "
    \e[32mPasswort hinzugefügt!\e[0m
    "
}

list_passwords() {
    read -sp "Dekodierung Passwort eingeben:
 >> " decryption_password
    echo ""

    echo "Gespeicherte Passwörter:
    "
    while IFS=',' read service username encrypted_password; 
    do
        password=$(decrypt_string "$encrypted_password" "$decryption_password")
        echo "Dienst: $service, Benutzername: $username, Passwort: $password"
    done < "$ENCRYPTION_LOCATION"
}

while true; do
    echo -e "\e[94mWillkommen zum Passwort Manager!\e[0m
    "
    echo "1. Passwort hinzufügen"
    echo "2. Passwörter anzeigen"
    echo "3. Abbrechen
    "

    read -p "Gebe deine Wahl ein (Zahl eingeben):     
 >> " choice
    echo ""

    case $choice in
        1) add_password ;;
        2) list_passwords ;;
        3) echo "Bricht ab..."
        break ;;
        *) echo -e "\e[31mDas ist keine Option!\e[0m
        " ;;
    esac
done 
