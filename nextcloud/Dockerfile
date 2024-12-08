FROM nextcloud:30.0.3

# Tune opcache
RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.interned_strings_buffer=32'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=256'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidate_freq=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini;

# Enable Redis session handler
RUN { \
        echo 'session.save_handler=redis'; \
        echo 'session.save_path="tcp://redis:6379?database=0"'; \
        echo 'redis.session.locking_enabled=1'; \
        echo 'redis.session.lock_retries=-1'; \
        echo 'redis.session.lock_wait_time=10000'; \
    } > /usr/local/etc/php/conf.d/php-redis.ini;

# Nextcloud dependencies
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
	libmagickcore-6.q16-6-extra \
	libbz2-dev \
	ffmpeg \
	intel-media-va-driver

# Updating libheif
RUN set -ex; \
    echo 'deb http://deb.debian.org/debian bookworm-backports main' >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
	libheif-plugins-all/stable-backports

RUN set -ex; \
    docker-php-ext-install bz2

RUN apt-get remove -y libtool automake autoconf pkgconf cmake build-essential git; \
	apt-get autoremove -y; \
    rm -rf /var/lib/apt/lists/*
