#!/bin/bash

    function getDocker() {
        # Docker Engine's Instalation
        # Add Docker's official GPG key:
        nala update
        nala install -y ca-certificates curl
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        chmod a+r /etc/apt/keyrings/docker.asc

        # Add the repository to Apt sources:
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null
        nala update
        nala install -y docker-compose
        nala install -y docker-ce docker-ce-cli docker-compose-plugin
    }   
    
ENDFLAG=false
while [ "$ENDFLAG" == false ] 
do
    clear
    #Feedback to the user
    if [ "$DOCKERGET" == true ] || [ "$ALLGET" == true ]; then
        DOCKER="\e[1;30;42m[Installing]\e[0m"
    else
        DOCKER="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$DESIGNGET" == true ]; then
        ENDFLAG=true
    fi

    PROMPT="\e[5m>\e[0m"

    echo -e "Please Indicate which module suites' to include in your install
    Then press 2 to install:
    
    [0] ALL

    [1] Docker Suite $DOCKER

    [2] Install Modules
    [x] Exit Prompt
    \e[5m>\e[0m" 
    read -r FLAG

    case "${FLAG}" in
        0 ) FLAG=All; ALLGET=true; ENDFLAG=true; ;;
        1 ) FLAG=Docker; 
            if [ "$DOCKERGET" == true ]; then 
                DOCKERGET=false
            else
                DOCKERGET=true
            fi ;;
        2 ) FLAG=Install; ENDFLAG=true; continue;;
        x ) FLAG=Exit; EXITFLAG=true;
    esac
    if [ "$EXITFLAG" == true ]; then
    echo "Exiting Install..."
    exit 1;
    fi
done
if [ "$DOCKERGET" == true ] || [ "$ALLGET" == true ]; then
    getDocker
fi