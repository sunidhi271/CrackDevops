#!/bin/bash

if (whoami != jenkins)
  then echo "Please run as jenkins"
  exit 1
fi

SRC="/var/lib/jenkins"
DST="/root/jenkins-backups/backup-$(date +%Y-%m-%d-%H-%M-%S)"
#DST="/root/jenkins-lite-backup-$(date +%Y-%m-%d-%H-%M-%S)"

echo "Creating backup directory $DST"
mkdir -p $DST

echo "Copying xmls..."
cp $SRC/*.xml $DST || { echo 'Copying xmls failed' ; exit 1; }

echo "Copying secrets..."
cp -rf $SRC/secret* $DST || { echo 'Copying secrets failed' ; exit 1; }

echo "Copying plugins..."
cp -rf $SRC/plugins $DST || { echo 'Copying plugins failed' ; exit 1; }

echo "Copying .kube"
cp -rf $SRC/.kube $DST || { echo 'Copying .kube failed' ; exit 1; }

echo "Copying .ssh..."
cp -rf $SRC/.ssh $DST || { echo 'Copying .ssh failed' ; exit 1; }

echo "Copying nodes..."
cp -rf $SRC/nodes $DST || { echo 'Copying nodes failed' ; exit 1; }

echo "Copying .m2..."
cp -rf $SRC/.m2 $DST || { echo 'Copying .m2 failed' ; exit 1; }


echo """
import os,shutil

root_src_dir = \"$SRC/jobs\"    #Path/Location of the source directory
root_dst_dir = \"$DST/jobs\"  #Path to the destination folder

for src_dir, dirs, files in os.walk(root_src_dir):
    #print(src_dir, dirs, files)
    if \"/builds/\" in src_dir:
        #print(\"Continuing.\")
        continue
    dst_dir = src_dir.replace(root_src_dir, root_dst_dir, 1)
    if not os.path.exists(dst_dir):
        os.makedirs(dst_dir)
    for file_ in files:
        src_file = os.path.join(src_dir, file_)
        dst_file = os.path.join(dst_dir, file_)
        #print(src_file)
        if os.path.exists(dst_file):
            os.remove(dst_file)
        try:
            shutil.copy(src_file, dst_dir)
        except Exception as e:
            print(\"Failed to create: {}. Exception: {}\".format(src_file,e))

""" > job-copier-tmp.py

cat job-copier-tmp.py

echo "Copying jobs..."

python job-copier-tmp.py || { echo 'Job content copy failed' ; exit 1; }

rm job-copier-tmp.py 

echo "Jenkins backup completed!!!"

