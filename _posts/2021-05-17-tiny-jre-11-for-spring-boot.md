---
title: Tiny JRE 11 for Spring boot Application
author: Louis Nguyen
date: 2021-05-17 16:00:00 +0700
categories: [Docker, Java, Spring boot]
tags: [docker, java, spring-boot]
pin: true
comments: true
---

### 1. Why we need to build a tiny docker image.
- Nowadays, almost applications will be deployed by docker image because it takes care the environment for us, your application will work properly if your host is good. It means that you deploy the host to run docker only, all other configurations already include in docker image.

- As you can see, before deploying or running, the system have to pull a matching image and it takes a few seconds or a minute. Actually, we have an option to pull the image at the first time only, then the system will cache the image. But if we want to re-pull the image with the same tag, the latest updating will not be applied.

- So my other option is resize the docker image, so we can pull the image more faster.

### 2. How to build a tiny docker image.
- I searched in the internet and I found an article which guides us how to build a tiny JRE (~70mb) to run our spring boot application. It also improves your productivity once you build docker image and do the deployment.

- Please refer this link [https://blog.gilliard.lol/2018/11/05/alpine-jdk11-images.html](https://blog.gilliard.lol/2018/11/05/alpine-jdk11-images.html) to checkout the source code.


### 3. Checkout the docker image.
- This docker image I got from [https://blog.gilliard.lol/2018/11/05/alpine-jdk11-images.html](https://blog.gilliard.lol/2018/11/05/alpine-jdk11-images.html) and both are same together.


```docker
FROM adoptopenjdk/openjdk11:alpine-slim AS jlink
RUN ["jlink", "--compress=2", \
     "--module-path", "/opt/java/openjdk/jmods", \
     "--add-modules", "java.base", \   # Maybe you need to add more modules here?
     "--output", "/jlinked"]           #   Use jdeps to find out.


FROM alpine

# This is the line from AdoptOpenJDK:
RUN apk --update add --no-cache ca-certificates curl openssl binutils xz \
    && GLIBC_VER="2.28-r0" \
    && ALPINE_GLIBC_REPO="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" \
    && GCC_LIBS_URL="https://archive.archlinux.org/packages/g/gcc-libs/gcc-libs-8.2.1%2B20180831-1-x86_64.pkg.tar.xz" \
    && GCC_LIBS_SHA256=e4b39fb1f5957c5aab5c2ce0c46e03d30426f3b94b9992b009d417ff2d56af4d \
    && ZLIB_URL="https://archive.archlinux.org/packages/z/zlib/zlib-1%3A1.2.9-1-x86_64.pkg.tar.xz" \
    && ZLIB_SHA256=bb0959c08c1735de27abf01440a6f8a17c5c51e61c3b4c707e988c906d3b7f67 \
    && curl -Ls https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -Ls ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-${GLIBC_VER}.apk > /tmp/${GLIBC_VER}.apk \
    && apk add /tmp/${GLIBC_VER}.apk \
    && curl -Ls ${GCC_LIBS_URL} -o /tmp/gcc-libs.tar.xz \
    && echo "${GCC_LIBS_SHA256}  /tmp/gcc-libs.tar.xz" | sha256sum -c - \
    && mkdir /tmp/gcc \
    && tar -xf /tmp/gcc-libs.tar.xz -C /tmp/gcc \
    && mv /tmp/gcc/usr/lib/libgcc* /tmp/gcc/usr/lib/libstdc++* /usr/glibc-compat/lib \
    && strip /usr/glibc-compat/lib/libgcc_s.so.* /usr/glibc-compat/lib/libstdc++.so* \
    && curl -Ls ${ZLIB_URL} -o /tmp/libz.tar.xz \
    && echo "${ZLIB_SHA256}  /tmp/libz.tar.xz" | sha256sum -c - \
    && mkdir /tmp/libz \
    && tar -xf /tmp/libz.tar.xz -C /tmp/libz \
    && mv /tmp/libz/usr/lib/libz.so* /usr/glibc-compat/lib \
    && apk del binutils \
    && rm -rf /tmp/${GLIBC_VER}.apk /tmp/gcc /tmp/gcc-libs.tar.xz /tmp/libz /tmp/libz.tar.xz /var/cache/apk/*

COPY --from=jlink /jlinked /opt/jdk/

## Add your application here, and change the CMD below to start it

CMD ["/opt/jdk/bin/java", "-version"]

```
