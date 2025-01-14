FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.15

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PROJECTSEND_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="TheSpad"

RUN \
  echo "**** install runtime packages ****" && \
  apk add -U --upgrade --no-cache \
  curl \
  php8-bcmath \
  php8-bz2 \
  php8-cli \
  php8-ctype \
  php8-curl \
  php8-dom \
  php8-fileinfo \
  php8-gd \
  php8-gettext \
  php8-gmp \
  php8-iconv \
  php8-json \
  php8-mbstring \
  php8-mysqli \
  php8-openssl \
  php8-pdo \
  php8-pdo_dblib \
  php8-pdo_mysql \
  php8-pecl-apcu \
  php8-pecl-mcrypt \
  php8-pecl-memcached \
  php8-phar \
  php8-soap \
  php8-xmlreader \
  php8-zip \
  unzip && \
  apk add --no-cache \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    php8-pecl-xmlrpc && \
  echo "**** install projectsend ****" && \
  mkdir -p /app/www/public && \
  if [ -z ${PROJECTSEND_VERSION+x} ]; then \
    PROJECTSEND_VERSION=$(curl -sX GET "https://api.github.com/repos/projectsend/projectsend/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -s -o \
    /tmp/projectsend.zip -L \
    "https://github.com/projectsend/projectsend/releases/download/${PROJECTSEND_VERSION}/projectsend-${PROJECTSEND_VERSION}.zip" && \
  unzip \
    /tmp/projectsend.zip -d \
    /app/www/public && \
  mv /app/www/public/upload /defaults/ && \
  mv /app/www/public /app/www/public-tmp && \
  echo "**** cleanup ****" && \
    rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
