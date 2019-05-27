#!/bin/bash
# Settings
DROPBOX_DIR="/backups" #Dropbox中的文件夹名称
BACKUP_SRC="/home/wwwroot/laobuluo.com /home/wwwroot/laojiang.me" #需要备份的文件夹路径，可以同时指定多个
BACKUP_DST="/tmp" #用来存放备份的文件夹路径
MYSQL_SERVER="127.0.0.1" #连接本地MySQL
MYSQL_USER="数据库用户" #本地MySQL的用户
MYSQL_PASS="数据库密码" #本地MySQL的密码

# Stop editing here
NOW=$(date +"%Y.%m.%d")
DESTFILE="$BACKUP_DST/$NOW.tgz"
LAST=$(date -d "2 months ago" +"%Y.%m.%d") #这里的时间可以根据需要进行修改，如"3 months ago"

# Backup files
ps -e | grep -c mysql
if [ $? -eq 0 ]; then
  echo "Dumping databases..."
  /usr/bin/mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS --all-databases > "$BACKUP_DST/$NOW-Databases.sql" #这里的命令路径可以根据需要进行修改
else
  echo "ERROR. Now exiting..."
  exit 1
fi

if [ $? -eq 0 ]; then
  echo "Packing files..."
  tar -czf "$DESTFILE" $BACKUP_SRC "$BACKUP_DST/$NOW-Databases.sql"
else
  echo "ERROR. Now exiting..."
  exit 1
fi

if [ $? -eq 0 ]; then
  /home/backup/dropbox_uploader.sh upload "$DESTFILE" "$DROPBOX_DIR/$NOW.tgz" #这里的脚本路径可以根据需要进行修改
else
  echo "ERROR. Now exiting..."
  exit 1
fi

# Delete old files
if [ $? -eq 0 ]; then
  /home/backup/dropbox_uploader.sh delete "$DROPBOX_DIR/$LAST.tgz" #这里的脚本路径可以根据需要进行修改
else
  echo "ERROR. Now exiting..."
  exit 1
fi

if [ $? -eq 0 ]; then
  echo "Cleaning the backups..."
  rm -f "$BACKUP_DST/$NOW-Databases.sql"
  rm -f "$BACKUP_DST/$LAST.tgz"
else
  echo "ERROR. Now exiting..."
  exit 1
fi