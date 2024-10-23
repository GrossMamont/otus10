#!/bin/bash

echo "Проверяем синтаксис и перезапускаем NGINX:"
sudo nginx -t
sudo nginx -s reload
echo "посмотрим с помощью curl"
curl -a http://localhost/repo/
echo "Добавим репозиторий в /etc/yum.repos.d:"
sudo cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

echo "Убедимся, что репозиторий подключился и посмотрим, что в нем есть"
sudo yum repolist enabled | grep otus

echo "Добавим пакет в наш репозиторий"
cd /usr/share/nginx/html/repo/
wget https://repo.percona.com/yum/percona-release-latest.noarch.rpm
echo "Обновим список пакетов в репозитории"
sudo createrepo /usr/share/nginx/html/repo/
sudo yum makecache
sudo yum list | grep otus
echo "Так как Nginx у нас уже стоит, установим репозиторий percona-release"
sudo yum install -y percona-release.noarch

