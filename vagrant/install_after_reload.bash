#!/usr/bin/env bash

#
#   Данный скрипт установит BitrixVM окружение.
#   В результате работы скрипта папка www должна заполниться дефолтными файлами (bitrixsetup.php, restore.php и прочее)
#   

echo "The installation of the Bitrix environment started. This may take some time..."

# Производим устровку VMBitrix
# Ключи: -s – Тихий режим установки; -p – Создать пул после установки окружения; -H – Имя хоста; -M – Пароль root для MySQL
sudo ./bitrix-env.sh -s -p -H bitrix -M 'root'

# Меняем права на директорию, чтоб потом можно было рабоать сней через sftp под пользователем vagrant 
sudo chown -R vagrant:bitrix /home/bitrix
# sudo chown -R bitrix:vagrant /home/bitrix
sudo chmod -R 777 /home/bitrix

# Включаем phar-файлы
sudo cp /etc/php.d/20-phar.ini.disabled /etc/php.d/20-phar.ini

# Composer
echo "Installing Composer"

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/sbin/composer

echo "Env install finished"

# Устанавливаем mbstring параметры в настройках PHP для работы Битрикс
sudo sed -i 's/;mbstring.internal_encoding =/mbstring.internal_encoding = UTF-8/' /etc/php.ini
sudo sed -i 's/;mbstring.func_overload = 0/mbstring.func_overload = 2/' /etc/php.ini
# Перезагружаем apache
sudo systemctl restart httpd

# Задаем пароль для MySQL иначе не получается подключиться к БД во установки Битрикс 
# mysql -uroot -p -e 'SET PASSWORD FOR "root"@"localhost" = PASSWORD("root"); FLUSH PRIVILEGES;'
# mysql -uroot -e 'SET PASSWORD FOR "root"@"localhost" = PASSWORD("root"); FLUSH PRIVILEGES;'
# Перезагружаем MySQL
# sudo service mysqld restart