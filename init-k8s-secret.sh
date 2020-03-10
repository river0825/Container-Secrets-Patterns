#!/bin/bash

INFO='\033[0;31m'
MARK='\033[0;32m'
NC='\033[0m'
HINT='\033[96m'
SEPERATOR='\033[95m'

echoAndWait()
{
    FOLDER=$(pwd |  awk -F "/"  '{print $NF}')
    echo -en "${HINT}${FOLDER} ${SEPERATOR}> ${NC} ${1} ${2}" 
    read
    eval ${1}
    echo ""
}

echoStep()
{
    echo ""
    echo -e "${INFO} ${1}${NC} ${2}"
    echo ""
}

mkdir k8s-test; cd k8s-test

echoStep "1. 預備 secret 的資訊"
echoAndWait "echo -n 'ftpadmin' > ./ftp-username"  "${MARK}# press Enter to continue${NC}"
echoAndWait "echo -n 'password-of-ftp' > ./ftp-password"
echoAndWait "echo -n 'dbadm' > ./db-username"
echoAndWait "echo -n 'password-of-db' > ./db-password"

echoStep "2. 將 secret 建立到 k8s 的中央環境中"
echoAndWait "kubectl create secret generic ftp-user-pass --from-file=./ftp-username --from-file=./ftp-password" "${MARK}# 建立 ftp password${NC}"
echoAndWait "kubectl create secret generic db-user-pass --from-file=./db-username --from-file=./db-password" "${MARK}# 建立 db password${NC}"
echoAndWait "kubectl get secrets" "${MARK}# 取得 secret${NC}"
echoAndWait "kubectl describe secrets/db-user-pass" "${MARK}# 取得 secret 的詳細資料${NC}"

echo Step "3. 存取控管 - 將 secret 佈署至 pod 中"
echoAndWait "kubectl apply -f https://raw.githubusercontent.com/river0825/Container-Secrets-Patterns/master/secret-envars-pod.yml" "${MARK}# 啟動 pod${NC}"
echoAndWait "kubectl exec -it secret-envars-test-pod -- /bin/bash -c 'printenv | grep -i SECRET'" "${MARK}# 進入 POD 中，將 secret 列出來，可以看到剛剛設定的 secret 已經變成環境變數了${NC}"

