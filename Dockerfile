FROM debian:bullseye-slim AS builder

ENV NGINX_VERSION 1.25.0

RUN apt update && \
    apt install -y \
    build-essential \
    curl \
    git \
    libpcre++-dev \
    zlib1g \ 
    zlib1g-dev \
    libpcre3-dev \
    libpcre3 \
    gcc \
    wget \
    vim

RUN curl http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o /tmp/nginx-${NGINX_VERSION}.tar.gz && \
    cd /tmp && \
    tar xvzf nginx-${NGINX_VERSION}.tar.gz

RUN cd /tmp/nginx-${NGINX_VERSION} && \
    ./configure --with-http_stub_status_module && \
    make && make install

FROM nginx:1.25

COPY --from=builder /tmp/nginx-${NGINX_VERSION}/objs/*_module.so /etc/nginx/modules/

COPY --from=builder /usr/local/lib/* /lib/x86_64-linux-gnu/

RUN rm /etc/nginx/conf.d/default.conf