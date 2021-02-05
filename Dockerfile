FROM nginx:alpine

RUN  apk add --no-cache --virtual .build-deps \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    linux-headers \
    libxslt-dev \
    gd-dev \
    geoip-dev \
    perl-dev \
    libedit-dev \
    mercurial \
    bash \
    alpine-sdk \
    findutils

# Download sources
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
    wget "https://github.com/yaoweibin/ngx_http_substitutions_filter_module/archive/v0.6.4.tar.gz" -O nginx_substitutions_filter.tar.gz

RUN rm -rf /usr/src/nginx /usr/src/extra_module && \
    mkdir -p /usr/src/nginx /usr/src/extra_module && \
    tar -zxC /usr/src/nginx -f nginx.tar.gz && \
    tar -zxC /usr/src/extra_module/ -f nginx_substitutions_filter.tar.gz
WORKDIR /usr/src/nginx/nginx-${NGINX_VERSION}
RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
    CONFARGS=${CONFARGS/-Os -fomit-frame-pointer/-Os} && \
    sh -c "./configure --with-compat $CONFARGS --add-module=/usr/src/extra_module/ngx_http_substitutions_filter_module-0.6.4" && \
    make && \
    make install

RUN rm -rf /usr/src/nginx/nginx-${NGINX_VERSION}

RUN apk del .build-deps \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    linux-headers \
    libxslt-dev \
    gd-dev \
    geoip-dev \
    perl-dev \
    libedit-dev \
    mercurial \
    bash \
    alpine-sdk

# Create the user and group
RUN addgroup -S -g 1000 www && adduser -S -D -u 1000 -G www www

# Create workdir
RUN mkdir /www && touch /www/docker-volume-not-mounted && chown www:www /www
WORKDIR /www
