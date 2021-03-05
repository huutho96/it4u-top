---
title: Build SDN System
author: Louis Nguyen
date: 2021-03-05 20:45:00 +0700
categories: [Learning Master, SDN System]
tags: [education, learning master]
pin: true
comments: true
---

# Build SDN System

======================================================================

### INTRODUCTION

This project builds a SND system. By the way, we can get knowledge about SDN, imagine the flow of a package inside the network and change this flow by ourselves.

- Reference from the project: [Machine Learning Approach for an Anomaly Intrusion Detection System using ONOS](https://github.com/blynotes/CS6301_SDN)
- Project Name: Build SDN System
- Professor: Le Kim Hung

======================================================================

### SETTING UP THE PROJECT

- Docker: https://docs.docker.com/get-docker/
- Dokcer Compose: https://docs.docker.com/compose/
- VS Code: https://code.visualstudio.com/
- Java 8: https://adoptopenjdk.net/
- Maven: https://maven.apache.org/

======================================================================

### FILES IN PROJECT DIRECTORY

- images:

  Please note that, these docker files can be change later, it depends on the jdk version 8 and ubuntu 16.04 images. Some packages, tools in this project you have to install separately.

  - [**_mininet_**](./images/mininet): There is a [Dockerfile](./images/mininet/Dockerfile) to build an image having Mininet inside.
  - [**_onos_**](./image/onos): There is a [Dockerfile](./images/onos/Dockerfile) to build an image having Onos inside.
  - [**_app_**](./images/app):
    - There is a [Dockerfile](./images/app/Dockerfile) to build an image having all softwares to run the project.
    - [_scripts_](./images/app/scripts): Run all files inside this folder step by step to run the project.

- [volumes](./volumes):

  - Contains all configs of these applications: elasticsearch, kafka, kibana, logstash, mininet, spark.
  - All output data will be saved here.

- [docker-compose.yml](./docker-compose.yml):

  - This file is used to initiate a system to run the project.
  - Share configuring and executing files to the application.
  - There is a network which is used to assign static IPs for 3 hosts inside: Onos, Mininet, App.

- [ifwd](./ifwd): A simple java project, we use it to monitor all the requests inside the network, then We can develop the algorithm to detect these requests to decide whether accept or reject them. Currently, we define a small Machine Learning application to do it.

- [referral](./referral): This is the source code of [Machine Learning Approach for an Anomaly Intrusion Detection System using ONOS](https://github.com/blynotes/CS6301_SDN) project.

- [onos-app-sample](./onos-app-sample): This is the source code of sample [ONOS apps](https://github.com/opennetworkinglab/onos-app-samples). I used it to develop the [ifwd](./ifwd) project.

- [UDP Kafka Producer.json](./UDP%20Kafka%20Producer.json): This is the Streams Set config file.

- Some other small scripts are used to clean the old data ([clean.sh](./clean.sh)) or connect to the host easier ([bash-root.sh](./bash-root.sh), [bash-elasticsearch.sh](./bash-elasticsearch.sh)).

======================================================================

### About ONOS and Mininet

- ONOS (Open Network Operating System) is a project of the Open Networking Foundation.
  - ONOS provides the control plane for SDN (Software-defined network) for the Mininet network.
  - It communicates with Mininet via OpenFlow.
  - It also receives REST API calls from the Big Data Infrastructure.

-Mininet (Miniature Network) is a software emulator for prototyping a large network on a single machine.

- It can be used to quickly create a realistic virtual network running actual kernel, switch and software application code on a personal computer. It allows the user to quickly create, interact with, customize and share a software-defined network (SDN) prototype to simulate a network topology that uses OpenFlow switches.
- In this project, it contains a realistic network architecture comprised of 9 "users with laptops", 3 "servers", and 10 Open vSwitches. 5 of the Open vSwitches are configured with NetFlow and forward those messages to the Big Data Infrastructure.

======================================================================

### Before running the project

- Your system should has atleast 6 GB memory and 10 GB disk space.
- If you see any "**louis**" word, this is my VM hostname. It's not important, you can change it if you want, but please remember to replace all the "**louis**" words in the source code.
- If you face any "permission denied" error, please try with sudo or admin account.

======================================================================

### Prepair your environment

- Build docker images:

  - ONOS

    ```shell
      cd images/onos
      docker build -t onos .
    ```

  - Mininet

    ```shell
      cd images/mininet
      docker build -t mininet .
    ```

  - App

    ```shell
      cd images/app
      docker build -t app .
    ```

- Complie Indent Reactive Forwarding project

  ```shell
    cd ifwd
    mvn clean package
  ```

======================================================================

### Run the project

- Start all host machines:
  ```shell
    docker-compose up
  ```
  You will see the onos, mininet and app will show the log and the status of them.
- Start all applications inside App VM:

  ```shell
  # 1st terminal
  bash bash-root.sh
  bash step_1-streamsets.sh
  ```

  Open [http://localhost:18630/](http://localhost:18630/), install Kafka Producer v1.0.0 package. Then import new pipeline from file [UDP Kafka Producer.json](./UDP%20Kafka%20Producer.json).

  ```shell
  # 2nd terminal
  bash bash-root.sh
  bash step_2-start-spark.sh
  ```

  You can check the status of Spark by access [http://localhost:8080/](http://localhost:8080/).

  ```shell
  # 3rd terminal
  bash bash-root.sh
  bash step_3-zookeeper-server.sh
  ```

  ```shell
  # 4th terminal
  bash bash-root.sh
  bash step_4-kafka-server.sh
  ```

  ```shell
  # 5th terminal
  bash bash-root.sh
  bash step_5-create-topic.sh
  ```

  You will see the work "NETFLOW" as the result.

  Then click on play button in Stream Set dashboard to start the pipeline.

  ```shell
  # 6th terminal
  bash bash-root.sh
  bash step_6-consumer-console.sh
  ```

  ```shell
  # 7th terminal
  bash bash-elasticsearch.sh
  bash step_7-start-es-kibana.sh
  ```

  Open [http://localhost:5601](http://localhost:5601) and go to Dev Tool, then run this [script](https://raw.githubusercontent.com/blynotes/CS6301_SDN/master/Code/src/index_ES.txt).

  ```shell
  # 8th terminal
  bash bash-elasticsearch.sh
  bash step_8-start-logstash.sh
  ```

  It will take few seconds to see the success message.

  ```shell
  # 9th terminal
  bash bash-root.sh
  bash step_9-capture-traffic.sh
  ```

  ```shell
  # 10th terminal
  bash bash-root.sh
  bash step_10-check-traffic.sh
  ```

  If you see any error at this step, I suggest that you can try again after seeing the data in kibana dashboard.

- Install Indent Reactive Forwarding project.

  - Open [http://localhost:8181/onos/ui/index.html](http://localhost:8181/onos/ui/index.html)
  - Open Application
  - Upload [onos-app-ifwd-1.9.0-SNAPSHOT.oar](./ifwd/target/onos-app-ifwd-1.9.0-SNAPSHOT.oar) file.
  - Select "Indent Reactive Forwarding" app in the list.
  - Click active app.

  If you can not access the GUI via browser (newer version is not supporting GUI), you should do it via CLI.

- Run mininet.

  - Access mininet
    ```shell
      docker exec -it mininet bash
    ```
  - Check python3, pip3, iputils-ping are existing and **requests** library is available for python3 or not.
  - Setup Topo
    ```shell
      python setup_topo.python
    ```
  - Now you can try to ping from h11 to h12
    ```shell
      h11 ping h12
    ```

Finally, you can check all the terminal's output and the data of Stream Set, Kibana.
