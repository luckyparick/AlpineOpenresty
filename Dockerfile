M isaackuang/alpine-base:3.8.0

ARG RESTY_VERSION="1.13.6.1"
ARG RESTY_OPENSSL_VERSION="1.0.2q"
ARG RESTY_PCRE_VERSION="8.42"
ARG RESTY_J="1"
ARG RESTY_CONFIG_OPTIONS="\
    --prefix=/etc/openresty \
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads \
    "
ARG _RESTY_CONFIG_DEPS="--with-openssl=/tmp/openssl-${RESTY_OPENSSL_VERSION} --with-pcre=/tmp/pcre-${RESTY_PCRE_VERSION}"

RUN apk add --no-cache --virtual .build-deps \
        build-base curl gd-dev geoip-dev libxslt-dev \
        linux-headers make perl-dev readline-dev zlib-dev && \
    apk add --no-cache gd geoip libgcc libxslt zlib git unzip openssl && \
    cd /tmp && \
    curl -fSL https://www.openssl.org/source/openssl-${RESTY_OPENSSL_VERSION}.tar.gz -o openssl-${RESTY_OPENSSL_VERSION}.tar.gz && \
    tar xzf openssl-${RESTY_OPENSSL_VERSION}.tar.gz && \
    curl -fSL https://ftp.pcre.org/pub/pcre/pcre-${RESTY_PCRE_VERSION}.tar.gz -o pcre-${RESTY_PCRE_VERSION}.tar.gz && \
    tar xzf pcre-${RESTY_PCRE_VERSION}.tar.gz && \
    curl -fSL https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz -o openresty-${RESTY_VERSION}.tar.gz && \
    tar xzf openresty-${RESTY_VERSION}.tar.gz && \
    cd /tmp/openresty-${RESTY_VERSION} && \
    ./configure -j${RESTY_J} ${_RESTY_CONFIG_DEPS} ${RESTY_CONFIG_OPTIONS} ${RESTY_CONFIG_OPTIONS_MORE} && \
    make -j${RESTY_J} && \
    make -j${RESTY_J} install && \
    cd /tmp && \
    rm -rf \
        openssl-${RESTY_OPENSSL_VERSION} \
        openssl-${RESTY_OPENSSL_VERSION}.tar.gz \
        openresty-${RESTY_VERSION}.tar.gz openresty-${RESTY_VERSION} \
        pcre-${RESTY_PCRE_VERSION}.tar.gz pcre-${RESTY_PCRE_VERSION} && \
    cd /tmp && \
    wget http://luarocks.github.io/luarocks/releases/luarocks-3.0.4.tar.gz && \
    tar zxvf luarocks-3.0.4.tar.gz && \
    cd luarocks-3.0.4/ && \
    ./configure \
        --prefix=/etc/openresty/luajit/ \
        --with-lua-bin=/etc/openresty/luajit/bin \
        --with-lua-include=/etc/openresty/luajit/include/luajit-2.1 && \
    make && make install && \
    ln -s /etc/openresty/luajit/bin/luarocks /usr/local/bin/. && \
    cd /tmp && \
    rm -rf luarocks* && \
    luarocks install dkjson && \
    apk del .build-deps


COPY config /

