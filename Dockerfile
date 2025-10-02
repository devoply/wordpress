FROM alpine:latest

LABEL   maintainer="Etopian Inc. <contact@etopian.com>" \
		devoply.type="site" \
		devoply.cms="wordpress" \
		devoply.framework="wordpress" \
		devoply.language.name="php" \
		devoply.language.version="8.3" \
		devoply.require="mariadb nginxproxy/acme-companion nginxproxy/acme-companion" \
		devoply.recommend="redis" \
		devoply.description="WordPress on Nginx and PHP-FPM with WP-CLI." \
		devoply.name="WordPress" \
		devoply.params="docker run -d --name {container_name} -e VIRTUAL_HOST={virtual_hosts} -v /data/sites/{domain_name}:/DATA etopian/alpine-php8.3-wordpress" \
		php.version=8.3


RUN apk update && \
	apk add --no-cache --virtual build-dependencies \
		build-base \
		php83-dev \
		php83-pear && \
	apk add --no-cache \
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
		rsync \
		tar \
		musl \
		ca-certificates \
		php83-apcu \
		php83-bcmath \
		php83-fpm \
		php83-ctype \
		php83-curl \
		php83-dom \
		php83-gd \
		php83-gettext \
		php83-gmp \
		php83-iconv \
		php83-intl \
		php83-json \
		php83-mysqli \
		php83-openssl \
		php83-opcache \
		php83-pdo \
		php83-pdo_mysql \
		php83-pgsql \
		php83-phar \
		php83-exif \
		php83-xmlreader \
		php83-xml \
		php83-xsl \
		php83-zip \
		php83-mbstring \
		php83-session \
		php83-apcu \
		php83-simplexml \
		php83-sodium \
		php83-zlib && \
	rm -rf /etc/nginx/* && \
	mkdir /etc/logrotate.docker.d && \
	pecl83 install redis && \
	apk del build-dependencies && \
	rm -rf /var/cache/apk/*

ENV PATH="/DATA/bin:$PATH" \
	TERM="xterm" \
	DB_HOST="172.17.0.1" \
	DB_NAME="" \
	DB_USER="" \
	DB_PASS="" \
	DB_HOST="" \
	PHP_MEMORY_LIMIT=256M \
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
	mv wp-cli.phar /usr/bin/wp-cli && \
	chown nginx:nginx /usr/bin/wp-cli && \
	mkdir -p /DATA/htdocs && \
	mkdir -p /DATA/logs/nginx && \
	mkdir -p /DATA/logs/php-fpm && \
	chown -R nginx:nginx /DATA

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 CMD curl -fsS http://127.0.0.1/health || exit 1

VOLUME ["/DATA"]

CMD ["/usr/bin/s6-svscan", "/etc/s6"]
