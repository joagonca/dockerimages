FROM nextcloud:27.1.4

RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.interned_strings_buffer=32'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=256'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidate_freq=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini;

RUN { \
        echo 'session.save_handler=redis'; \
        echo 'session.save_path="tcp://redis:6379?database=0"'; \
        echo 'redis.session.locking_enabled=1'; \
        echo 'redis.session.lock_retries=-1'; \
        echo 'redis.session.lock_wait_time=10000'; \
    } > /usr/local/etc/php/conf.d/php-redis.ini;

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        libmagickcore-6.q16-6-extra \
    ; \
    rm -rf /var/lib/apt/lists/*
