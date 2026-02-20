#!/bin/bash

yum update -y
yum install -y httpd php php-mysqlnd php-pecl-redis php-json wget

echo "<?php phpinfo(); ?>" > /var/www/html/info.php
systemctl start httpd
systemctl enable httpd
