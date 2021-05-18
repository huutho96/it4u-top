---
title: Kong Solution for Microservices System
author: Louis Nguyen
date: 2021-05-16 16:00:00 +0700
categories: [Kong, Java, Spring boot, Microservices]
tags: [kong, java, spring-boot, microservices]
pin: true
comments: true
---

### 1. My current opinion: Spring Cloud + Eureka Netflix and Zuul Gateway.
- I've worked with Eureka Netflix and Zuul Gateway for 2 years and developed atleast 3 products with this solution. They are working properly.

- I don't want to change current system to other solution because it takes so much time. But I only deployed all applications to a server with 4gb memory and this is not enough.

- So I changed to Kong Solution and I found many helpful things.
    - Reduce the total containers.
    - Reduce memory, cpu.
    - Kong Ingress and Kong Identity are very helpfull.
    - Some other advantages such as: deploying, configuration, etc.

### 2. Offer for you and me.
- I suggest these 2 articles we should read and apply to our systems.
    - [Kong Ingress](https://konghq.com/blog/kubernetes-ingress-api-gateway)
    - [JWT Plugin](https://docs.konghq.com/hub/kong-inc/jwt/)
