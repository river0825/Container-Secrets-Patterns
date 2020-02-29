# 0. 安裝 git-crypt [以 MacOS 為例]
echo "1. 建立空的 repository"
mkdir git-crypt-test
## 利用 folder 模擬遠端的 git repository
mkdir remote-repo
cd remote-repo; git init --bare; cd ..
## 將資料從遠端的 repository clone 到 local
git clone ./remote-repo client-with-git-crypt

echo "2. 在 clone 出來的 repository 中設定 git-crypt"
cd client-with-git-crypt
echo "secretfile filter=git-crypt diff=git-crypt" > .gitattributes
## 這裡可以設定要加密的檔案, 比對到的檔案會自動進行加解密
echo "*.key filter=git-crypt diff=git-crypt" >> .gitattributes
git-crypt init
git-crypt export-key ../key-of-git-crypt #將 key 匯出來

echo "3. 新增檔案，一個會被加密，另一個不會"
echo "It will be encrypted" > aa.key
echo "It will not be encrypted" > bb.txt
git add *; git add .gitattributes
git commit -m "initial commit"
git push
cd ..
