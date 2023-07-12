FROM alpine:latest
MAINTAINER Etopian Inc. <contact@etopian.com>

LABEL   devoply.type="site" \
        devoply.cms="wordpress" \
        devoply.framework="wordpress" \
        devoply.language.name="php" \
        devoply.language.version="8.1" \
        devoply.require="mariadb etopian/nginx-proxy" \
        devoply.recommend="redis" \
        devoply.description="WordPress on Nginx and PHP-FPM with WP-CLI." \
        devoply.name="WordPress" \
        devoply.params="docker run -d --name {container_name} -e VIRTUAL_HOST={virtual_hosts} -v /data/sites/{domain_name}:/DATA etopian/alpine-php8.1-wordpress"



RUN  apk update \
        && apk add --no-cache \
        bash \
        dcron \
        less \
        vim \
        openssl \
        nginx \
        shadow \
        s6 \
        logrotate \
        gettext \
        bash-completion \
        curl \
        mariadb-client \
        openssh-client \
        git \
        curl \
        rsync \
        tar \
        musl \
        ca-certificates \
        php81-apcu \
        php81-dev \
        php81-bcmath \
        php81-fpm \
        php81-ctype \
        php81-curl \
        php81-dom \
        php81-gd \
        php81-gettext \
        php81-gmp \
        php81-iconv \
        php81-intl \
        php81-json \
        php81-mysqli \
        php81-openssl \
        php81-opcache \
        php81-pdo \
        php81-pdo_mysql \
        php81-pear \
        php81-pgsql \
        php81-phar \
        php81-exif \
        php81-xmlreader \
        php81-xml \
        php81-xsl \
        php81-dom \
        php81-zip \
        php81-dev \
        php81-mbstring \
        php81-session \
        php81-apcu \
        php81-simplexml \
        php81-sodium \
        php81-zlib \
        build-base && \
        rm -rf /etc/nginx/* && \
        mkdir /etc/logrotate.docker.d && \
        pecl81 install redis && \
        apk del build-base && \
        apk del php81-dev && \
        apk del php81-pear && \
        rm -rf /var/cache/apk/*

ENV PATH="/DATA/bin:$PATH" \
    TERM="xterm" \
    DB_HOST="172.17.0.1" \
    DB_NAME="" \
    DB_USER="" \
    DB_PASS="" \
    DB_HOST="" \
    PHP_MEMORY_LIMIT=128M \
    PHP_POST_MAX_SIZE=2G \
    PHP_UPLOAD_MAX_FILESIZE=2G \
    PHP_MAX_EXECUTION_TIME=3600 \
    PHP_MAX_INPUT_TIME=3600 \
    PHP_DATE_TIMEZONE=UTC \
    PHP_LOG_LEVEL=warning \
    PHP_MAX_CHILDREN=25 \
    PHP_MAX_REQUESTS=500 \
    PHP_PROCESS_IDLE_TIMEOUT=10s \
    NGINX_WORKER_PROCESSES="auto" \
    NGINX_WORKER_CONNECTIONS=4096 \
    NGINX_SENDFILE=on \
    NGINX_TCP_NOPUSH=on \
    REDIS_HOST=172.17.0.1 \
    REDIS_PORT=6379 \
    REDIS_DB=0

ADD rootfs /

RUN sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/DATA:\/bin\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/DATA:\/bin\/bash/g" /etc/passwd- && \
    chmod +x /usr/bin/wp-config-devoply && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/bin/wp && \
    chown nginx:nginx /usr/bin/wp && \
    mkdir -p /DATA/htdocs && \
    mkdir -p /DATA/logs/nginx && \
    mkdir -p /DATA/logs/php-fpm && \
    chown -R nginx:nginx /DATA

EXPOSE 80

VOLUME ["/DATA"]


CMD ["/bin/s6-svscan", "/etc/s6"]
