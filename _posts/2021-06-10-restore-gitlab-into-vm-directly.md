---
title: Restore Gitlab into VM directly.
author: Louis Nguyen
date: 2021-06-10 16:00:00 +0700
categories: [Docker, Docker compose, Gitlab]
tags: [docker, docker-compose, gitlab]
pin: true
comments: true
---

## 1. Deploy an empty instance of Gitlab with docker compose.

Please note:
- Current version of [http://gitlab.it4u.top](http://gitlab.it4u.top) is `gitlab-ce:13.9.3`.
- List of ports will be occupated by Gitlab [here](https://docs.gitlab.com/omnibus/package-information/defaults.html).
- List of versions and matching operating systems [here](https://packages.gitlab.com/gitlab/).
- In our case, we are using CentOS 8 and the matching version of Gitlab is `gitlab-ce-13.9.3-ce.0.el8.aarch64.rpm`.
- Install an instance Gitlab.
```bash
sudo yum localinstall gitlab-ce-13.9.3-ce.0.el8.aarch64.rpm
```
- Run a below command to check status of Gitlab's services.
```bash
sudo gitlab-ctl status
```


## 2. Restore our Gitlab.

- Check Gitlab's document [here](https://docs.gitlab.com/ee/raketasks/backup_restore.html#restore-for-omnibus-gitlab-installations).
- In our case, `1619888267_2021_05_01_13.9.3_gitlab_backup.tar` is our backup file.
- Copy the backup file to `/var/opt/gitlab/backups/` (***manatory***).
```bash
sudo cp gitlab/1619888267_2021_05_01_13.9.3_gitlab_backup.tar /var/opt/gitlab/backups/
```
- Change owner of backup file.
```bash
sudo chown git.git /var/opt/gitlab/backups/1619888267_2021_05_01_13.9.3_gitlab_backup.tar
```
- Run below commands with your backup file name(not includes `_gitlab_backup.tar`) and container name (*note to run below command with a flag `-it`*):
```bash
# Stop the processes that are connected to the database
sudo gitlab-ctl stop puma
sudo gitlab-ctl stop sidekiq

# Verify that the processes are all down before continuing
sudo gitlab-ctl status

# Run the restore
sudo gitlab-backup restore BACKUP=1619888267_2021_05_01_13.9.3
```

## 3. Restore our configurations.

- Download 2 files named `gitlab-secrets.json` and `gitlab.rb` from our old Gitlab server (inside `/etc/gitlab/`).
    - `gitlab-secrets.json`: The most important file which uses to decrypt our Gitlab's sensitive datas.
    - `gitlab.rb`: Contains domain/ssl/email/etc configs.
- Copy these 2 files to `/etc/gitlab/`.
```bash
sudo cp ./gitlab/gitlab-secrets.json /etc/gitlab/
sudo cp ./gitlab/gitlab.rb /etc/gitlab/
```
- Then reconfigure the Gitlab.
```bash
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
sudo gitlab-rake gitlab:check SANITIZE=true
```

## 4. Config SSL:
- Please go [here](https://it4u.top/posts/gitlab-server/#1-create-ssl) to prepair the SSL config files.
- In our case, we are trying to enable SSL for `gitlab.it4u.top`.
- So, we have 2 files named `gitlab.it4u.top.crt` and `gitlab.it4u.top.key` inside `/etc/gitlab/ssl/`.
- Replace these below lines with matching lines of `/etc/gitlab/gitlab.rb`.
```bash
# If it not exists, just add these lines at the beginning of file.
nginx['listen_https'] = true
nginx['listen_port'] = 443
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/gitlab.it4u.top.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/gitlab.it4u.top.key"
nginx['ssl_protocols'] = "TLSv1.1 TLSv1.2"
nginx['proxy_set_headers'] = {
  "X-Forwarded-Proto" => "https",
  "X-Forwarded-Ssl" => "on"
}
```
- Finally, restart Nginx via Gitlab.
```bash
sudo gitlab-ctl restart nginx
```
