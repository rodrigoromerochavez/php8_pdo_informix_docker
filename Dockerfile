
FROM php:8.0.17-apache-buster

# Provide Files
ADD ./PDO_INFORMIX-1.3.6.tgz /informix-pdo
ADD ./ibm.csdk.4.50.FC11.LNX.tar /informix-sdk
ADD ./csdk.properties /informix-sdk

# Prepare Install SDK
# Install required dependencies including Java
RUN apt-get update && apt-get install -y \
    libaio1 \
    libstdc++6 \
    libpam0g \
    fonts-freefont-ttf \
    openjdk-11-jre \
    build-essential \
    libxml2-dev --allow-unauthenticated \
    rpm \
    libncurses5 && mkdir -p /var/lib/rpm && rpm --initdb

#soap dependences for php
RUN docker-php-ext-install soap && docker-php-ext-enable soap


# Create installation directory
RUN  mkdir -p /opt/IBM/Informix_Client-SDK

ENV INFORMIXDIR=/opt/IBM/Informix_Client-SDK

# Install SDK
RUN chmod -R 777 /informix-sdk
RUN cd /informix-sdk/ &&\
	./installclientsdk -i silent -f csdk.properties


# Install PDO, add extension to php, 

RUN cd /informix-pdo/PDO_INFORMIX-1.3.6/ && \
	phpize && \
    ./configure --with-pdo-informix=/opt/IBM/Informix_Client-SDK && \
    make && \
    make install INSTALL_ROOT=/ && \
    echo "extension=pdo_informix.so" > /usr/local/etc/php/conf.d/pdo.ini 

# Clean up
RUN rm -rf /tmp/*

 
# Informix environment variables for Apache
COPY apache_conf/envvars.sh /tmp/
RUN sh /tmp/envvars.sh

# Copy configuration files
COPY apache_conf/php.ini /usr/local/etc/php/
COPY apache_conf/sqlhosts $INFORMIXDIR/etc/
RUN echo "sqlexec  9088/tcp\nsqlexec-ssl  9089/tcp" >> /etc/services

ADD apache_conf/apache-config.conf /etc/apache2/sites-enabled/000-default.conf
ADD apache_conf/apache-config.conf /etc/apache2/sites-available/000-default.conf


RUN echo "ServerName informix.local" >> /etc/apache2/apache2.conf

#RUN echo "127.0.0.1 informix.local" >> /etc/hosts

RUN a2enmod rewrite
COPY src/index.php /var/www/html/

#CMD ["apache2-foreground"]
