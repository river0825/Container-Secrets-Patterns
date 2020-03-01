#!/bin/bash

INFO='\033[0;31m'
MARK='\033[0;32m'
NC='\033[0m'
HINT='\033[96m'
SEPERATOR='\033[95m'

echoAndWait()
{
    FOLDER=$(pwd |  awk -F "/"  '{print $NF}')
    echo -e "${HINT}${FOLDER} ${SEPERATOR}> ${NC} ${1} ${2}" 
    read
    eval ${1}
    echo ""
}

echoStep()
{
    echo ""
    echo -e "${INFO} ${1}${NC}"
    echo ""
}

mkdir k8s-test; cd k8s-test

echoStep "1. 預備 secret 的資訊"
echoAndWait "echo -n 'ftpadmin' > ./ftp-username"
echoAndWait "echo -n 'password-of-ftp' > ./ftp-password"
echoAndWait "echo -n 'dbadm' > ./db-username"
echoAndWait "echo -n 'password-of-db' > ./db-password"

echoAndWait "kubectl create secret generic ftp-user-pass --from-file=./ftp-username --from-file=./ftp-password" "建立 ftp password"
echoAndWait "kubectl create secret generic db-user-pass --from-file=./db-username --from-file=./db-password" "建立 db password"
