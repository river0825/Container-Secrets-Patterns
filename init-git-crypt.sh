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

apt update; apt install git-crypt; 
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global push.default simple

# 0. 安裝 git-crypt [以 MacOS 為例]
echoStep "1. 建立空的 repository"
mkdir git-crypt-test; cd git-crypt-test
## 利用 folder 模擬遠端的 git repository
mkdir remote-repo
cd remote-repo; git init --bare; cd ..
## 將資料從遠端的 repository clone 到 local
git clone ./remote-repo client-with-git-crypt

echo ""
echoStep "2. 在 clone 出來的 repository 中設定 git-crypt${NC}"

cd client-with-git-crypt
echo "secretfile filter=git-crypt diff=git-crypt" > .gitattributes
## 這裡可以設定要加密的檔案, 比對到的檔案會自動進行加解密
echo "*.key filter=git-crypt diff=git-crypt" >> .gitattributes
git-crypt init
git-crypt export-key ../key-of-git-crypt #將 key 匯出來

echoStep "3. 新增檔案，一個會被加密，另一個不會.${NC}"
echo '> echo "It will be encrypted" > aa.key'
echo '> echo "It will not be encrypted" > bb.txt'
echo "It will be encrypted" > aa.key
echo "It will not be encrypted" > bb.txt
read

echoStep "4. 將檔案加入 git 之中${NC}"
echo "> git add *; git add .gitattributes
> git commit -m "initial commit"
> git push"
read;

git add *; git add .gitattributes
git commit -m "initial commit"
git push

echoStep "5. 檢查檔案是否真的被加密${NC}"
echoAndWait "git-crypt status"

echoAndWait "cat aa.key" "${MARK}#來看一下 aa.key 的內容${NC}"
echoAndWait "" "${MARK}#因為這個目錄是處理 unlock 的狀態。所以 aa.key 目前還是明碼${NC}"
echoAndWait "cat bb.txt" "${MARK}#來看一下 bb.txt 的內容${NC}"
echoAndWait "git-crypt lock"  "${MARK}#進行 lock${NC}"
echoAndWait "cat aa.key" "${MARK}#再來看一下 aa.key 及 bb.txt 的內容${NC}"
echoAndWait "cat bb.txt"

cd ..

echoStep "6. 將 git repository clone 到另外一個目錄中"
echoAndWait "git clone ./remote-repo client-without-git-crypt; cd client-without-git-crypt"
echoAndWait "cat aa.key" "${MARK}#在新的目錄中 aa.key 應該預設為加密的${NC}"
echoAndWait "cat bb.txt" "${MARK}#在新的目錄中 bb.txt 應該為明碼${NC}"

echoStep "7. 執行完畢，準備清理目錄"
cd ..; cd ..
pwd
echoAndWait "rm -rf git-crypt-test" "${MARK}#執行完畢，不想清理目錄請按下 ctrl-c${NC}"
