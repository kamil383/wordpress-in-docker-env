FROM ubuntu:18.04
ENV TZ=Europe
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN    apt-get update  && apt-get install -y \
       apache2  \
       php-mysql \
       mysql-server\
       php \
       php-bcmath \
       php-curl \
       php-imagick \
       php-intl \
       php-json \
       php-mbstring \
       php-mysql \
       php-xml \
       php-zip 

COPY   wordpress-6.1.1.tar.gz /srv/www/
COPY   wordpress.conf /etc/apache2/sites-available/ 
COPY   init.sql /


RUN    chown -R www-data:www-data /srv/www && \
       cd /srv/www/ && \  
       tar -xf wordpress-6.1.1.tar.gz 

EXPOSE 80

RUN    a2ensite wordpress && \
       a2enmod rewrite   && \
       a2dissite 000-default 

RUN    echo "ServerName localhost" >> /etc/apache2/apache2.conf 


RUN cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php

RUN    sed -i 's/database_name_here/wordpress/' /srv/www/wordpress/wp-config.php && \
       sed -i 's/username_here/wordpress/' /srv/www/wordpress/wp-config.php && \
       sed -i 's/password_here/1234/' /srv/www/wordpress/wp-config.php 


CMD service mysql start;mysql -u root < init.sql; /usr/sbin/apachectl -D FOREGROUND;


