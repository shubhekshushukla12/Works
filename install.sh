#Install operating system packages
yum install httpd php php-mysql php-gd php-xml mariadb-server mariadb php-mbstring

#Database (MySQL) post-install configuration

#For Red Hat Enterprise Linux 7 and 8: Start MariaDB and secure it:

systemctl start mariadb
mysql_secure_installation

#Log into MySQL client:

mysql -u root -p

#At the database prompt, Create the wiki user:

CREATE USER 'wiki'@'localhost' IDENTIFIED BY 'Password1';
#Create the database:

CREATE DATABASE wikidatabase;

#Grant privileges to newly created DB:

GRANT ALL PRIVILEGES ON wikidatabase.* TO 'wiki'@'localhost';
FLUSH PRIVILEGES;

SHOW DATABASES;
exit

#Autostart webserver and database daemons (services)

systemctl enable mariadb
systemctl enable httpd

#Install MediaWiki tarball ("sources")

cd /home/username (e.g username - ec2-user)
yum install wget -y
wget https://releases.wikimedia.org/mediawiki/1.34/mediawiki-1.34.2.tar.gz

wget https://releases.wikimedia.org/mediawiki/1.34/mediawiki-1.34.2.tar.gz.sig
gpg --verify mediawiki-1.34.2.tar.gz.sig mediawiki-1.34.2.tar.gz

cd /var/www
tar -zxf /home/username/mediawiki-1.34.2.tar.gz
ln -s mediawiki-1.34.2/ mediawiki

#Webserver (Apache) post-install configuration
#changes done under httpd.conf

sudo sed -i s/DocumentRoot "/var/www/html"/DocumentRoot "/var/www"/ /etc/httpd/conf/httpd.conf
   
sudo sed -i s/DirectoryIndex index.html/DirectoryIndex index.html index.html.var index.php/ /etc/httpd/conf/httpd.conf

#After that 
cd /var/www
ln -s mediawiki-1.34.2/ mediawiki
chown -R apache:apache /var/www/mediawiki-1.34.2 

#Restart Apache
service httpd restart

#Firewall configuration
yum install firewalld -y

systemctl enable firewalld
systemctl start firewalld
systemctl status firewalld

#Enable both the https and http services 
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
systemctl restart firewalld


#Security (selinux) configuration
getenforce
restorecon -FR /var/www/mediawiki-1.34.2/
restorecon -FR /var/www/mediawiki

ls -lZ /var/www/



#DocumentRoot

