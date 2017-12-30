FROM tfirdaus/wp-docklines:php7.2-apache

ARG WP_WORKDIR=/var/www/html
WORKDIR $WP_WORKDIR

COPY ./config/wp-locker-php.ini /usr/local/etc/php/conf.d/
COPY ./config/wp-config-sample.php /usr/src/wordpress/
COPY ./config/wp-locker.conf /etc/apache2/sites-available/
COPY ./config/wp-locker-ssl.conf /etc/apache2/sites-available/
COPY ./ssl/certs/wp-locker-crt.pem /etc/ssl/certs/
COPY ./ssl/certs/wp-locker-key.pem /etc/ssl/private/

RUN chown www-data:www-data -R /var/www/html/ \
	&& a2enmod ssl \
	&& a2ensite wp-locker \
	&& a2ensite wp-locker-ssl

EXPOSE 80 443
