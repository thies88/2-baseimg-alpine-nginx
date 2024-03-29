FROM 1-base-alpine:3.15

# install packages
RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache \
    apache2-utils \
    git \
    #libressl3.6-libssl \
    logrotate \
    nano \
    nginx \
    openssl \
    php7 \
    php7-fileinfo \
    php7-fpm \
    php7-json \
    php7-mbstring \
    php7-openssl \
    php7-session \
    php7-simplexml \
    php7-xml \
    php7-xmlwriter \
    php7-zlib && \
	apk search -qe 'libressl*-libssl' | xargs apk add && \
  echo "**** configure nginx ****" && \
  echo 'fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> \
    /etc/nginx/fastcgi_params && \
  rm -f /etc/nginx/http.d/default.conf && \
  echo "**** fix logrotate ****" && \
  sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
  sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' \
    /etc/periodic/daily/logrotate

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
