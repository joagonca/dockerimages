FROM nextcloud:30.0.2 AS builder
# Common dependencies for all stages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libtool automake autoconf pkgconf cmake build-essential git \
    libjpeg-dev liblcms2-dev libopenjp2-7-dev liblqr-1-0-dev \
    liblzma-dev libpangocairo-1.0-0 libpango1.0-dev libpng-dev \
    libraw-dev libtiff-dev libwebp-dev libwmf-dev libxml2-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Stage 1: Build libde265
FROM builder AS libde265-builder
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


# Stage 2: Build libheif
FROM builder AS libheif-builder
RUN set -ex; \
    git clone -b v1.18.2 https://github.com/strukturag/libheif.git libheif; \
    cd libheif; \
    mkdir build; \
    cd build; \
    cmake --preset=release ..; \
    make; \
    make install; \
    cd ../..

# Stage 3: Build ImageMagick
FROM builder AS imagemagick-builder
RUN set -ex; \
    git clone -b 6.9.13-16 https://github.com/ImageMagick/ImageMagick6.git ImageMagick; \
    cd ImageMagick; \
    ./configure; \
    make; \
    make install; \
    ldconfig /usr/local/lib; \
    cd ..

# Final Nextcloud Image
FROM nextcloud:30

# Copy compiled libraries from each previous stage
COPY --from=libde265-builder /usr/local/lib /usr/local/lib
COPY --from=libheif-builder /usr/local/lib /usr/local/lib
COPY --from=imagemagick-builder /usr/local/lib /usr/local/lib

# Update library paths
RUN ldconfig

# Configure PHP and Redis settings
RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.interned_strings_buffer=32'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=256'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidate_freq=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini && \
    { \
        echo 'session.save_handler=redis'; \
        echo 'session.save_path="tcp://nc-redis:6379?database=0"'; \
        echo 'redis.session.locking_enabled=1'; \
        echo 'redis.session.lock_retries=-1'; \
        echo 'redis.session.lock_wait_time=10000'; \
    } > /usr/local/etc/php/conf.d/php-redis.ini

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
