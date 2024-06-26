#!/bin/bash

INDEX=0
CNT=0
FILES=()

function ShowDir() {
    echo -e "\e[1;35mPWD=$PWD\e[0m"
    i=0
    FILES=()
    for f in $(ls $PWD); do
        FILES+=($f)

        flag=f
        if [ -d $PWD/$f ]; then
            flag=d
        fi

        if [ $INDEX -eq $i ]; then
            echo -e "\e[1;32m${flag} ${f}\e[0m"
        else
            if [ "$flag" == "d" ]; then
                echo -e "\e[34m${flag} ${f}\e[0m"
            else
                echo "${flag} ${f}"
            fi
        fi

        i=$((i+1))
    done

    CNT=$i
}

function ClearLine() {
    cnt=$1

    for((i=0; i<$cnt; i++)); do
        echo -en "\033[1A"          # 光标上移一行
        echo -en "\033[K"           # 清除当前行
    done
}

function g() {
    ShowDir

    while true; do
        IFS= read -r -d '' -n 1 char
        echo -en "\r\033[K"

        case $char in
        j)
            INDEX=$((INDEX + 1))
            if [ $INDEX -eq $CNT ]; then
                INDEX=0
            fi

            ClearLine $((CNT+1))
            ShowDir
            ;;
        k)
            INDEX=$((INDEX - 1))
            if [ $INDEX -lt 0 ]; then
                INDEX=$(($CNT - 1))
            fi

            ClearLine $((CNT+1))
            ShowDir
            ;;
        l | $'\n')
            if [ -d $PWD/${FILES[$INDEX]} ]; then
                cd $PWD/${FILES[$INDEX]}
                INDEX=0

                if [ "$char" == "l" ]; then
                    ClearLine $((CNT+1))
                else
                    ClearLine $((CNT+2))
                fi

                ShowDir
            elif [ "$char" == $'\n' ]; then
                ClearLine 1
            fi
            ;;
        h)
            INDEX=0
            cd ..

            ClearLine $((CNT+1))
            ShowDir
            ;;
        q)
            break
            ;;
        *)
            continue
            ;;
        esac
    done
}