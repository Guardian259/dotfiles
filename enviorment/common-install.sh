#!/bin/bash

ENDCOMMONFLAG=false
while [ "$ENDCOMMONFLAG" == false ] 
do
    clear
    #Feedback to the user
    if [ "$SHELLPROMPTGET" == true ] || [ "$ALLCOMMONGET" == true ]; then
        SHELLPROMPT="\e[1;30;42m[Installing]\e[0m"
    else
        SHELLPROMPT="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$RANGERGET" == true ] || [ "$ALLCOMMONGET" == true ]; then
        RANGER="\e[1;30;42m[Installing]\e[0m"
    else
        RANGER="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$PACSTALLGET" == true ] || [ "$ALLCOMMONGET" == true ]; then
        PACSTALL="\e[1;30;42m[Installing]\e[0m"
    else
        PACSTALL="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$SHELLPROMPTGET" == true ] && [ "$RANGERGET" == true ] && [ "$PACSTALLGET" == true ]; then
        ENDCOMMONFLAG=true
    fi
    PROMPT="\e[5m>\e[0m"
    echo -e "Please Indicate which modules to include in your base install
    Then press 4 to install:

    [0] ALL

    [1] Custom Shell Prompt w/ Git Repo Branch Version $SHELLPROMPT
    [2] Ranger CLI file manager $RANGER
    [3] Pacstall - The AUR for Ubuntu $PACSTALL

    [4] Install Modules
    [5] Exit Prompt
    $PROMPT"
    read -r COMMONFLAG
    case "${COMMONFLAG}" in
        0 ) COMMONFLAG=All; ALLCOMMONGET=true; ENDCOMMONFLAG=true; ;;
        1 ) COMMONFLAG=Yakuake;
            if [ "$SHELLPROMPTGET" == true ]; then 
                SHELLPROMPTGET=false
            else
                SHELLPROMPTGET=true
            fi ;;
        2 ) COMMONFLAG=Firefox;
            if [ "$RANGERGET" == true ]; then 
                RANGERGET=false
            else
                RANGERGET=true
            fi ;;
        3 ) COMMONFLAG=Programming;
            if [ "$PACSTALLGET" == true ]; then 
                PACSTALLGET=false
            else
                PACSTALLGET=true
            fi ;;
        4 ) COMMONFLAG=Install; ENDCOMMONFLAG=true; continue;;
        5 ) COMMONFLAG=Exit; return;
    esac
done
TOPENDFLAG=false
while [ "$TOPENDFLAG" == false ]
do
    clear
    #Feedback to the user
    if [ "$HTOPGET" == true ] || [ "$ALLTOPGET" == true ]; then
        HTOP="\e[1;30;42m[Installing]\e[0m"
    else
        HTOP="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$BTOPGET" == true ] || [ "$ALLTOPGET" == true ]; then
        BTOP="\e[1;30;42m[Installing]\e[0m"
    else
        BTOP="\e[30;1;40m[Not Installing]\e[0m"
    fi
    if [ "$HTOPGET" == true ] && [ "$BTOPGET" == true ]; then
        TOPENDFLAG=true
    fi

    PROMPT="\e[5m>\e[0m"

    echo -e "Please Indicate which Task Manager to include in your install
    Then press 9 to install:

    [0] ALL

    [1] Htop $HTOP
    [2] Btop $BTOP

    [9] Install
    [x] Exit Prompt
    \e[5m>\e[0m"
    read -r FLAG

    case "${FLAG}" in
        0 ) FLAG=All; ALLTOPGET=true; TOPENDFLAG=true; ;;
        1 ) FLAG=htop;
            if [ "$HTOP" == true ]; then
                HTOPGET=false
            else
                HTOPGET=true
            fi ;;
        2 ) FLAG=btop;
            if [ "$BTOP" == true ]; then
                BTOPGET=false
            else
                BTOPGET=true
            fi ;;
        9 ) FLAG=Install; TOPENDFLAG=true; continue;;
        x ) FLAG=Exit; EXITFLAG=true;
    esac
    if [ "$EXITFLAG" == true ]; then
    echo "Exiting Install..."
    exit 1;
    fi
done

echo "Installing Nala..."
apt install -y nala
echo "Fetching Mirrors..."
nala fetch && nala update
echo "Installing fzf..."
nala install fzf

#Neofetch has been abandoned; Depreciated
#echo "Installing Neofetch..."
#nala install -y neofetch

echo "Installing Fastfetch..."
add-apt-repository ppa:zhangsongcui3371/fastfetch
nala update
nala install -y fastfetch
if [ "$HTOPGET" == true ] || [ "$ALLTOPGET" == true ]; then
    echo "installing Htop..."
    nala install -y htop
fi
if [ "$BTOPGET" == true ] || [ "$ALLTOPGET" == true ]; then
    echo "installing Btop..."
    nala install -y btop   
fi

for file in shell/*
do
    fullpath=$(realpath "$file")
    #Appending Nala onto bashrc
    if [ "$file" = shell/nala.sh ]; then
        echo "Appending ${file} into ~/.bashrc..."
        echo "source $fullpath" >> ~/.bashrc
        echo "Appending ${file} into /root/.bashrc..."
        echo "source $fullpath" >> /etc/bash.bashrc
    fi
    #Appending Shell Prompt onto bashrc
    if [ "$file" != shell/nala.sh ] && [ "$SHELLPROMPTGET" == true ]; then
        echo "Appending ${file} into ~/.bashrc..."
        echo "source $fullpath" >> ~/.bashrc
    fi
done
if [ "$RANGERGET" == true ]; then
    echo "Installing Ranger..."
    apt install -y ranger
fi

if [ "$PACSTALLGET" == true ]; then
    echo "Installing PacStall..."
    bash -c "$(curl -fsSL https://pacstall.dev/q/install)"
fi