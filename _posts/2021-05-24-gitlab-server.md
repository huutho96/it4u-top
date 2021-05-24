---
title: Deploy Gitlab server with docker-compose
author: Louis Nguyen
date: 2021-05-24 16:00:00 +0700
categories: [Docker, Docker compose, Gitlab]
tags: [docker, docker-compose, gitlab]
pin: true
comments: true
---

Because both of us already knew about Gitlab, so I'm not focus on "What is gitlab?" and "How to use Gitlab?", etc.

In this post, I just offer you the way to deploy and config SSL for gitlab server.

### 1. Create SSL
- I downloaded SSL from [https://sslforfree.com](https://sslforfree.com).
- You just open this website, register an account
- Create a certificate.
- Fill your information and domain name.
- This system will ask you to prove that domain is yours, so you can prove by CNAME address.
- Then download certificate to your system. It includes 3 files and we need to send 2 files below to docker-compose to config the server.
  - /etc/ssl/certs/gitlab/certificate.crt
  - /etc/ssl/certs/gitlab/private.key


### 2. Deploy server
I deployed this gitlab server via docker compose. I think you can do the same with k8s or docker only.
- Refer my docker compose file below, then update your docker compose such as domain name, config, logs, data paths, etc.


```yaml
version: "3"
services:
  gitlab:
    container_name: "gitlab"
    image: 'gitlab/gitlab-ee:13.9.3-ee.0'
    restart: always
    hostname: 'gitlab.it4u.top'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'https://gitlab.it4u.top:443'
        gitlab_rails['gitlab_shell_ssh_port'] = 2222

        nginx['listen_https'] = true
        nginx['listen_port'] = 443
        nginx['redirect_http_to_https'] = true
        nginx['ssl_certificate'] = "/etc/ssl/certs/gitlab/certificate.crt"
        nginx['ssl_certificate_key'] = "/etc/ssl/certs/gitlab/private.key"
        nginx['ssl_protocols'] = "TLSv1.1 TLSv1.2"
        nginx['proxy_set_headers'] = {
          "X-Forwarded-Proto" => "https",
          "X-Forwarded-Ssl" => "on"
        }
    ports:
      - '80:80'
      - '443:443'
      - '2222:22'
    volumes:
      - '/root/louis/ssl:/etc/ssl/certs/gitlab/'
      - '/srv/gitlab/config:/etc/gitlab'
      - '/srv/gitlab/logs:/var/log/gitlab'
      - '/srv/gitlab/data:/var/opt/gitlab'
    deploy:
      resources:
        limits:
          cpus: 2
          memory: 3G
        reservations:
          cpus: 1
          memory: 2G

```

- Then run:
```shell
docker-compose up
```
- It will take few minutes to complete, so please wait.
- After completing, you can access the service from the internet via your domain name.
- The admin username is root and the server will ask you can change the password of root user before using.
