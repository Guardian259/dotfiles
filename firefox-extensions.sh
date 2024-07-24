#!/bin/bash
    function firefoxExtensionPrompts() {
        EXTENSIONSENDFLAG=false
        while [ "$EXTENSIONSENDFLAG" == false ]
        do
            clear
            #Feedback to the user
            if [ "$MULTIACCOUNTGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                MULTIACCOUNT="\e[1;30;42m[Installing]\e[0m"
            else
                MULTIACCOUNT="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$LIBRARYGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                LIBRARY="\e[1;30;42m[Installing]\e[0m"
            else
                LIBRARY="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$SCIHUBGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                SCIHUB="\e[1;30;42m[Installing]\e[0m"
            else
                SCIHUB="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$MALSYNCGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                MALSYNC="\e[1;30;42m[Installing]\e[0m"
            else
                MALSYNC="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$UBLOCKGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                UBLOCK="\e[1;30;42m[Installing]\e[0m"
            else
                UBLOCK="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$DISLIKEGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                DISLIKE="\e[1;30;42m[Installing]\e[0m"
            else
                DISLIKE="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$ARRPLUGINGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                ARRPLUGIN="\e[1;30;42m[Installing]\e[0m"
            else
                ARRPLUGIN="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$USERAGENTGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                USERAGENT="\e[1;30;42m[Installing]\e[0m"
            else
                USERAGENT="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$SAUCENAOGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                SAUCENAO="\e[1;30;42m[Installing]\e[0m"
            else
                SAUCENAO="\e[30;1;40m[Not Installing]\e[0m"
            fi
            if [ "$MULTIACCOUNTGET" == true ] && [ "$LIBRARYGET" == true ] && [ "$SCIHUBGET" == true ] && [ "$MALSYNCGET" == true ] && [ "$UBLOCKGET" == true ] && [ "$DISLIKEGET" == true ] && [ "$ARRPLUGINGET" == true ] && [ "$USERAGENTGET" == true ] && [ "$SAUCENAOGET" == true ]; then
                EXTENSIONSENDFLAG=true
            fi

            PROMPT="\e[5m>\e[0m"

            echo -e "Please Indicate which Extension Packages to include in your install
            Then press I to install:

            **NOTE CURRENTLY CHOICES ARE NON-FUNCTIONAL, ALL EXTENSIONS WILL BE INSTALLED**

            [0] ALL

            [1] Multi-Account Container $MULTIACCOUNT
            [2] Library Genesis $LIBRARY
            [3] Sci-Hub $SCIHUB
            [4] Mal-Sync $MALSYNC
            [5] UBlock Origin & Sponsor Block $UBLOCK
            [6] Return Youtube Dislike Button $DISLIKE
            [7] Sonarr-Radarr-Lidarr Search $ARRPLUGIN
            [8] User Agent String Switcher $USERAGENT
            [9] Search By Image & Saucenao Fetcher $SAUCENAO

            [I] Install Extensions
            [x] Exit Prompt
            \e[5m>\e[0m"
            read FLAG

            case "${FLAG}" in
                0 ) FLAG=All; ALLEXTENSIONGET=true; ENDFLAG=true; ;;
                1 ) FLAG=multiaccount;
                    if [ "$MULTIACCOUNT" == true ]; then
                        MULTIACCOUNTGET=false
                    else
                        MULTIACCOUNTGET=true
                    fi ;;
                2 ) FLAG=library;
                    if [ "$LIBRARY" == true ]; then
                        LIBRARYGET=false
                    else
                        LIBRARYGET=true
                    fi ;;
                3 ) FLAG=scihub;
                    if [ "$SCIHUB" == true ]; then
                        SCIHUBGET=false
                    else
                        SCIHUBGET=true
                    fi ;;
                4 ) FLAG=malsync;
                    if [ "$MALSYNC" == true ]; then
                        MALSYNCGET=false
                    else
                        MALSYNCGET=true
                    fi ;;
                5 ) FLAG=ublock;
                    if [ "$UBLOCK" == true ]; then
                        UBLOCKGET=false
                    else
                        UBLOCKGET=true
                    fi ;;
                6 ) FLAG=dislike;
                    if [ "$DISLIKE" == true ]; then
                        DISLIKEGET=false
                    else
                        DISLIKEGET=true
                    fi ;;
                7 ) FLAG=arrplugin;
                    if [ "$ARRPLUGIN" == true ]; then
                        ARRPLUGINGET=false
                    else
                        ARRPLUGINGET=true
                    fi ;;
                8 ) FLAG=useragent;
                    if [ "$USERAGENT" == true ]; then
                        USERAGENTGET=false
                    else
                        USERAGENTGET=true
                    fi ;;
                9 ) FLAG=saucenao;
                    if [ "$SAUCENAO" == true ]; then
                        SAUCENAOGET=false
                    else
                        SAUCENAOGET=true
                    fi ;;
                I ) FLAG=Install; EXTENSIONSENDFLAG=true; continue;;
                x ) FLAG=Exit; EXITFLAG=true;
            esac
            if [ "$EXITFLAG" == true ]; then
            echo "Exiting Install..."
            exit 1;
            fi

            CUR_DIR=$(pwd)
            echo "${CUR_DIR}"
            touch policies.json
            echo "source ${CUR_DIR}/components/policies-start.txt" >> policies.json
            echo "source ${CUR_DIR}/bookmarks/bookmarks.txt" >> policies.json
            echo "source ${CUR_DIR}/components/extensions-start.txt" >> policies.json
            if [ "$MULTIACCOUNTGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                echo "source ${CUR_DIR}/extensions/multi-account.txt" >> policies.json
            fi
            if [ "$LIBRARYGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                echo "source ${CUR_DIR}/extensions/lybrarygen.txt" >> policies.json
            fi
            if [ "$SCIHUBGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                echo "source ${CUR_DIR}/extensions/scihub.txt" >> policies.json
            fi
            if [ "$MALSYNCGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                echo "source ${CUR_DIR}/extensions/mal-sync.txt" >> policies.json
            fi
            if [ "$UBLOCKGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                echo "source ${CUR_DIR}/extensions/ublock-sponsorblock.txt" >> policies.json
            fi
            if [ "$DISLIKEGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                echo "source ${CUR_DIR}/extensions/dislike.txt" >> policies.json
            fi
            if [ "$ARRPLUGINGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                echo "source ${CUR_DIR}/extensions/arr.txt" >> policies.json
            fi
            if [ "$USERAGENTGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                echo "source ${CUR_DIR}/extensions/useragent.txt" >> policies.json
            fi
            if [ "$SAUCENAOGET" == true ] || [ "$ALLEXTENSIONGET" == true ]; then
                echo "source ${CUR_DIR}/extensions/sauce.txt" >> policies.json
            fi
            echo "source ${CUR_DIR}/components/extensions-end.txt" >> policies.json
            echo "source ${CUR_DIR}/components/policies-end.txt" >> policies.json
        done
    }

    firefoxExtensionPrompts