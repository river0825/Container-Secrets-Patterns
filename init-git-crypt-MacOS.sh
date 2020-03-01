#!/bin/bash

INFO='\033[0;31m'
MARK='\033[0;32m'
NC='\033[0m'

# 0. 安裝 git-crypt [以 MacOS 為例]
echo -e "${INFO} 1. 建立空的 repository${NC}"
mkdir git-crypt-test; cd git-crypt-test
## 利用 folder 模擬遠端的 git repository
mkdir remote-repo
cd remote-repo; git init --bare; cd ..
## 將資料從遠端的 repository clone 到 local
git clone ./remote-repo client-with-git-crypt

echo ""
echo -e "${INFO} 2. 在 clone 出來的 repository 中設定 git-crypt${NC}"
cd client-with-git-crypt
echo "secretfile filter=git-crypt diff=git-crypt" > .gitattributes
## 這裡可以設定要加密的檔案, 比對到的檔案會自動進行加解密
echo "*.key filter=git-crypt diff=git-crypt" >> .gitattributes
git-crypt init
git-crypt export-key ../key-of-git-crypt #將 key 匯出來

echo "--------- git repository 設定完成 --------"
echo "Press any key to continue."
read

echo ""
echo -e "${INFO} 3. 新增檔案，一個會被加密，另一個不會.${NC}"
echo "--------- 接下來將會執行下列指令 --------"
echo '> echo "It will be encrypted" > aa.key'
echo '> echo "It will not be encrypted" > bb.txt'
echo ""
echo "Press any key to continue."
read
echo "It will be encrypted" > aa.key
echo "It will not be encrypted" > bb.txt
git add *; git add .gitattributes
git commit -m "initial commit"
git push

echo ""
echo -e "${INFO} 4. 檢查檔案是否真的被加密${NC}"
echo "--------- 接下來將會執行下列指令 --------"
echo "> git-crypt status"
echo ""
git-crypt status

echo ""
echo "在這裡應該可以看到 aa.key 會被加密，但因為這個目錄是處理 unlock 的狀態。所以目前還是明碼"

echo ""
echo -e "> cat aa.key ${MARK}#來看一下 aa.key 的內容${NC}"
cat aa.key

echo ""
echo "上面應該會看到一串明碼"
read

echo "cat bb.txt"
echo ""
echo "Press any key to continue."
read


cd ..

rm -rf git-crypt-test
