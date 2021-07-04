---
title: Restore Gitlab via Docker compose
author: Louis Nguyen
date: 2021-06-10 16:00:00 +0700
categories: [Docker, Docker compose, Gitlab]
tags: [docker, docker-compose, gitlab]
pin: true
comments: true
---

## Restore Gitlab via Docker compose

### 1. Deploy an empty instance of Gitlab with docker compose.

Please note:
- Current version of [http://gitlab.it4u.top](http://gitlab.it4u.top) is `gitlab-ce:13.9.3`.
- No need to config anything because almost configs will be restored in next steps.
```yaml
web:
  image: 'gitlab/gitlab-ce:13.9.3-ce.0'
  restart: always
  hostname: 'gitlab.propzy.local'
  environment:
    GITLAB_OMNIBUS_CONFIG: |

  ports:
    - '80:80'
    - '2222:22'
  volumes:
    - '/home/centos/gitlab/config:/etc/gitlab'
    - '/home/centos/gitlab/logs:/var/log/gitlab'
    - '/home/centos/data:/var/opt/gitlab'
    - '/path/to/backup/1619888267_2021_05_01_13.9.3_gitlab_backup.tar:/var/opt/gitlab/backups/1619888267_2021_05_01_13.9.3_gitlab_backup.tar'
```
- Start the docker instance
```bash
docker-compose up -d
```
- Check your [http://localhost](http://localhost) till it is ready and rerirects to password config page.

### 2. Restore our Gitlab.

- Check Gitlab's document [here](https://docs.gitlab.com/ee/raketasks/backup_restore.html#restore-for-docker-image-and-gitlab-helm-chart-installations).
- In our case, `1619888267_2021_05_01_13.9.3_gitlab_backup.tar` is our backup file.
- Share the backup file with gitlab container at `/var/opt/gitlab/backups/` (***manatory***).
```yaml
  volumes:
    - ...
    - './1619888267_2021_05_01_13.9.3_gitlab_backup.tar:/var/opt/gitlab/backups/1619888267_2021_05_01_13.9.3_gitlab_backup.tar'
```
- Start the docker instance again.
```bash
docker-compose up -d
```
- Find the container name.
```bash
docker ps

#CONTAINER ID   IMAGE                          NAMES
#d9b533ba73d0   gitlab/gitlab-ee:13.9.3-ee.0   centos_web_1
```
- Run below commands with your backup file name(not includes `_gitlab_backup.tar`) and container name (*note to run below command with a flag `-it`*):
```bash
# Stop the processes that are connected to the database
docker exec -it centos_web_1 gitlab-ctl stop puma
docker exec -it centos_web_1 gitlab-ctl stop sidekiq

# Verify that the processes are all down before continuing
docker exec -it centos_web_1 gitlab-ctl status

# Run the restore
docker exec -it centos_web_1 gitlab-backup restore BACKUP=1619888267_2021_05_01_13.9.3

# Restart the GitLab container
docker restart centos_web_1

# Check GitLab
docker exec -it centos_web_1 gitlab-rake gitlab:check SANITIZE=true
```

### 3. Restore our configurations.

- Download 2 files named `gitlab-secrets.json` and `gitlab.rb` from our old Gitlab server (inside `/etc/gitlab/`).
    - `gitlab-secrets.json`: The most important file which uses to decrypt our Gitlab's sensitive datas.
    - `gitlab.rb`: Contains domain/ssl/email/etc configs.
- Share these 2 files with container at `/etc/gitlab/`.
```yaml
  volumes:
    - ...
    - './gitlab-secrets.json:/etc/gitlab/gitlab-secrets.json'
    - './gitlab.rb:/etc/gitlab/gitlab.rb'
```
- Start the docker instance again.
```bash
docker-compose up -d
```

- Then reconfigure the Gitlab.
```bash
docker exec gitlab-ctl reconfigure
docker exec gitlab-ctl restart
docker exec gitlab-rake gitlab:check SANITIZE=true
```

### 4. Config SSL:

- Please go [here](https://it4u.top/posts/gitlab-server/.) to config the SSL.
