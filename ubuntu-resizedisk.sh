#!/bin/bash

#### PREREQUISITE ####
# 1. run only on ubuntu
# 2. add execute on the script (chmod +x ubuntu-resizedisk.sh)
# 3. run the script "sudo bash ubuntu-resizedisk.sh"

echo "--------EXTEND DISK--------"
read -r -p "Please run as with sudo, do you want to proceed? [yes|NO]" proceed

resize(){
    sudo growpart /dev/sda 3
    sudo pvresize /dev/sda3
    sudo lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
    sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
}

if [[ "$proceed" =~ ^[Yy][Ee][Ss]$ ]]
then
      echo "proceed to resize disk"
      resize
else
    echo "exiting"
    exit 0
fi
