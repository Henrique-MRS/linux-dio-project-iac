#!/bin/bash

echo "Atualizando e instalando os pacotes necessários..."
apt-get update
apt-get upgrade -y
apt-get install -y apache2
apt-get install unzip -y

echo "Baixando e copiando os arquivos da aplicação..."
cd /tmp
wget https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip
unzip main.zip
cd linux-site-dio-main
cp -R * /var/www/html/