# WordPress with Nginx and PHP-FPM Docker Image

This Docker image provides a complete WordPress setup running on Nginx and PHP-FPM 8.3. It includes WP-CLI for WordPress
management and is built on Alpine Linux for a minimal footprint.

## Features

- WordPress with Nginx and PHP-FPM 8.3
- Built on Alpine Linux
- Includes WP-CLI
- S6 process supervisor
- Redis support
- Built-in cron support

## Environment Variables

### Database Configuration

- `DB_HOST`: Database host (default: 172.17.0.1)
- `DB_NAME`: Database name
- `DB_USER`: Database user
- `DB_PASS`: Database password

### PHP Configuration

- `PHP_MEMORY_LIMIT`: PHP memory limit (default: 256M)
- `PHP_POST_MAX_SIZE`: Maximum POST size (default: 2G)
- `PHP_UPLOAD_MAX_FILESIZE`: Maximum file upload size (default: 2G)
- `PHP_MAX_EXECUTION_TIME`: Maximum execution time (default: 3600)
- `PHP_MAX_INPUT_TIME`: Maximum input time (default: 3600)
- `PHP_DATE_TIMEZONE`: PHP timezone (default: UTC)
- `PHP_LOG_LEVEL`: PHP log level (default: warning)
- `PHP_MAX_CHILDREN`: PHP-FPM max children (default: 25)
- `PHP_MAX_REQUESTS`: PHP-FPM max requests (default: 500)
- `PHP_PROCESS_IDLE_TIMEOUT`: PHP-FPM process idle timeout (default: 10s)

### Nginx Configuration

- `NGINX_WORKER_PROCESSES`: Number of worker processes (default: auto)
- `NGINX_WORKER_CONNECTIONS`: Maximum connections per worker (default: 4096)
- `NGINX_SENDFILE`: Enable sendfile (default: on)
- `NGINX_TCP_NOPUSH`: Enable TCP NOPUSH (default: on)

### Redis Configuration

- `REDIS_HOST`: Redis host (default: 172.17.0.1)
- `REDIS_PORT`: Redis port (default: 6379)
- `REDIS_DB`: Redis database number (default: 0)

## A simple example
### Say you want to run a single site on a VPS with Docker

```bash

mkdir -p /data/sites/etopian.com/htdocs

sudo docker run -e VIRTUAL_HOST=etopian.com,www.etopian.com -v /data/sites/etopian.com:/DATA -p 80:80 etopian/alpine-php-wordpress

```
The following user and group id are used, the files should be set to this:
User ID:
Group ID:

```bash
chown -R 100:101 /data/sites/etopian.com/htdocs
```

### Say you want to run a multiple WP sites on a VPS with Docker

```bash

sudo docker run -p 80:80 devoply/wordpress
mkdir -p /data/sites/etopian.com/htdocs

sudo docker run -e VIRTUAL_HOST=etopian.com,www.etopian.com -v /data/sites/etopian.com:/DATA devoply/wordpress

mkdir -p /data/sites/etopian.net/htdocs
sudo docker run -e VIRTUAL_HOST=etopian.net,www.etopian.net -v /data/sites/etopian.net:/DATA devoply/wordpress
```

Populate /data/sites/etopian.com/htdocs and  /data/sites/etopian.net/htdocs with your WP files. See http://www.wordpressdocker.com if you need help on how to configure your database.

The following user and group id are used, the files should be set to this:
User ID:
Group ID:

```bash
chown -R 100:101 /data/sites/etopian.com/htdocs
```



### Volume structure

* `htdocs`: Webroot
* `logs`: Nginx/PHP error logs
*

### WP-CLI

This image now includes [WP-CLI](wp-cli.org) baked in... So you can. Please `su nginx` before executing or else you can potentially compromise your host.

```
docker exec -it <container_name> bash
su nginx
cd /DATA/htdocs
wp-cli cli
```

### Multisite

For each multisite you need to give the domain as the -e VIRTUAL_HOST parameter. For instance VIRTUAL_HOST=site1.com,www.site1.com,site2.com,www.site2.com ... if you wish to add more sites you need to recreate the container.

### Upload limit

The upload limit is 2 gigabyte.

### Change php.ini value
modify files/php-fpm.conf

To modify php.ini variable, simply edit php-fpm.ini and add php_flag[variable] = value.

```
php_flag[display_errors] = on
```

Additional documentation on http://www.wordpressdocker.com

## Questions or Support

https://gitter.im/etopian/devoply

## Docker WordPress Control Panel

DEVOPly is a free hosting control panel which does everything taught in this tutorial automatically and much more, backups, staging/dev/prod, code editor, Github/Bitbucket deployments, DNS, WordPress Management. https://www.devoply.com
