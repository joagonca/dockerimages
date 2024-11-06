FROM nextcloud:30.0.1

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

# Install build dependencies
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    libtool automake autoconf pkgconf cmake build-essential git

# Install Imagemagick build dependencies
RUN apt-get install -y --no-install-recommends \
    zlib1g-dev libzstd-dev fontconfig libraqm-dev libgvc6 \
    libjpeg-dev liblcms2-dev libopenjp2-7-dev liblqr-1-0-dev \
    liblzma-dev openexr libpangocairo-1.0-0 libpango1.0-dev \
    libpng-dev libraw-dev libtiff-dev libwebp-dev libwebpmux3 libwmf-dev libxml2-dev

# Install libde265 (libheif build dependency)
RUN set -ex; \
    git clone -b v1.0.15 https://github.com/strukturag/libde265.git libde265; \
    cd libde265; \
    ./autogen.sh; \
    ./configure; \
    mkdir build; \
    cd build; \
    cmake ..; \
    make; \
    make install; \
    cd ../..

# Install libheif (Imagemagick build dependency)
RUN set -ex; \
    git clone -b v1.18.2 https://github.com/strukturag/libheif.git libheif; \
    cd libheif; \
    mkdir build; \
    cd build; \
    cmake --preset=release ..; \
    make; \
    make install; \
    cd ../..

# Install Imagemagick
RUN set -ex; \
    git clone -b 6.9.13-16 https://github.com/ImageMagick/ImageMagick6.git ImageMagick; \
    cd ImageMagick; \
    ./configure; \
    make; \
    make install; \
    ldconfig /usr/local/lib; \
    cd ..

# Nextcloud dependencies
RUN set -ex; \
    apt-get install -y --no-install-recommends \
#	libmagickcore-6.q16-6-extra \
	libbz2-dev \
	ffmpeg \
	intel-media-va-driver

RUN set -ex; \
    docker-php-ext-install bz2

# Cleanup
RUN rm -rf libde265; \
    rm -rf libheif; \
    rm -rf ImageMagick

RUN apt-get remove -y libtool automake autoconf pkgconf cmake build-essential git; \
	apt-get autoremove -y; \
    rm -rf /var/lib/apt/lists/*
