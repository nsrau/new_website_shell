#!/bin/bash

echo " "
echo "###################################"
echo "# New website                     #"
echo "# Script                          #"
echo "###################################"
echo " "

read -p "Enter the domain of the site (ex: domain.com): " SITE
echo "=> Current user $USER"
read -p "Enter your user name (for path Sites folder) : " SITEPATH_USER

if [[ ! -z $SITEPATH_USER ]]
then
    SITEPATH="/Users/$SITEPATH_USER/Sites/$SITE"
    echo "the path will be : ${SITEPATH}"
    mkdir -m 755 $SITEPATH
    mkdir -m 755 $SITEPATH/httpdocs
    mkdir -m 755 $SITEPATH/logs
    mkdir -m 755 $SITEPATH/ssp
    echo "folders ${SITEPATH} created successfully..."
    echo "***********************************"
else
    echo "Error, the user is invalid!"
    echo "***********************************"
fi

HOSTS="/private/etc/hosts"

#/etc/hosts
if cp $HOSTS ${HOSTS}.original
then
    echo "Backup file ${HOSTS}.original created..."
    echo "127.0.0.1 ${SITE} www.${SITE}" >> ${HOSTS}
    echo "File ${HOSTS} modified..."
    echo "***********************************"
else
    echo "Error, file $HOSTS unmodified."
    echo "***********************************"
fi

#httpd-vhosts.conf
VHOSTSFILE="/etc/apache2/extra/httpd-vhosts.conf"
if cp $VHOSTSFILE ${VHOSTSFILE}.original
then
    echo "" >> ${VHOSTSFILE}
    echo "<VirtualHost *:80>" >> ${VHOSTSFILE}
    echo "   ServerName ${SITE}" >> ${VHOSTSFILE}
    echo "   ServerAlias www.${SITE}" >> ${VHOSTSFILE}
    echo '   DocumentRoot "'${SITEPATH}'/httpdocs"' >> ${VHOSTSFILE}
    echo '   ErrorLog "'${SITEPATH}'/logs/error_log"' >> ${VHOSTSFILE}
    echo '   CustomLog "'${SITEPATH}'/logs/access_log" common' >> ${VHOSTSFILE}
    echo "</VirtualHost>" >> ${VHOSTSFILE}
    echo "Backup file $VHOSTSFILE.original created..."
    echo "File $VHOSTSFILE modified..."
    echo "***********************************"
else
    echo "Error, file http-vhosts.conf unmodified"
    echo "***********************************"
fi

APACHE="y"

if [ $APACHE == "y" ]
then
    sudo apachectl restart
    echo "Apache restarted!"
    echo "***********************************"
else
    echo "Apache Apache not start!"
    echo "***********************************"
fi

echo " "
echo "Fine!!!"
echo " "
