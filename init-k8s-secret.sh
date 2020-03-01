#!/bin/bash
mkdir k8s-test; cd k8s-test

echo -n 'ftpadmin' > ./ftp-username
echo -n 'password-of-ftp' > ./ftp-password
echo -n 'dbadm' > ./db-username
echo -n 'password-of-db' > ./db-password

kubectl create secret generic ftp-user-pass --from-file=./ftp-username --from-file=./ftp-password
secret "ftp-user-pass" created