#!/usr/bin/expect
# set timeout 1
spawn mysql -u root -p
# expect "Enter password:"
# send "root\r\n"
# expect "mysql>"
# send "/\q\r\n"
# expect eof


spawn sudo mysql -u root -p
expect "Enter password:"
send "root\r\n"
expect "mysql>"
send "/\q\r\n"


spawn sudo mysql

expect "mysql>"
send "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root'); FLUSH PRIVILEGES;\r\n"
expect "mysql>"
send "/\q\r\n"

mysql -uroot -p -e 'SET PASSWORD FOR "root"@"localhost" = PASSWORD("root"); FLUSH PRIVILEGES;'