#!/bin/bash

echo "Compile software in a specific directory"
sudo rpmbuild -ba /root/rpmbuild/SPECS/nginx.spec -D 'debug_package %{nil}'
echo "Убедимся, что пакеты создались"
sudo ls -l /root/rpmbuild/RPMS/x86_64/
echo "Теперь можно установить наш пакет и убедиться, что nginx работает"
sudo cp /root/rpmbuild/RPMS/noarch/* /root/rpmbuild/RPMS/x86_64/
sudo yum localinstall -y /root/rpmbuild/RPMS/x86_64/*.rpm
echo "Make sure a service unit is running"
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx


#Теперь приступим к созданию своего репозитория
echo "Теперь приступим к созданию своего репозитория"
echo "Создадим каталог repo"
sudo mkdir /usr/share/nginx/html/repo
echo "Копируем туда наши собранные RPM-пакеты"
sudo cp /root/rpmbuild/RPMS/x86_64/*.rpm /usr/share/nginx/html/repo/
echo "Инициализируем репозиторий"
sudo createrepo /usr/share/nginx/html/repo/

