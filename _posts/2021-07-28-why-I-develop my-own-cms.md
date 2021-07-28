---
title: Why I develop my own CMS.
author: Louis Nguyen
date: 2021-07-28 22:00:00 +0700
categories: [Blogging, CMS]
tags: [cms]
pin: true
comments: true
---

I develop my own CMS because these reasons mentioned below.

## 1. Avaiable CMSs.

<table>
  <thead>
    <tr>
      <th>Language</th>
      <th>Available CMS</th>
      <th>Advantage</th>
      <th>Disavantage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>PHP</td>
      <td>
        <ul>
          <li>Most of them are developed by PHP because:
            <ul>
              <li>SXIMO.</li>
              <li>Botble.</li>
            </ul>
          </li>
        </ul>
      </td>
      <td>
        <ul>
          <li>Easy: we can add more plugins during runtime environment.</li>
          <li>Community: So much PHP developer.</li>
          <li>Popular: Document, structure, example, ...</li>
          <li>Provide both Backend/Frontent.</li>
        </ul>
      </td>
      <td>
        <ul>
          <li>Can not compile to protect source code.</li>
          <li>Focus on shoping, design, landing page, ...</li>
          <li>License: easy to clone to new instance.</li>
          <li>Difficult to connect with other system.</li>
          <li>Can not use free version or open source version because maintenance service.</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>JAVA, DotNET</td>
      <td>
        <ul>
          <li>umbraco.</li>
          <li>piranha.</li>
          <li>craftercms</li>
          <li>dotcms</li>
        </ul>
      </td>
      <td>
        <ul>
          <li>License: the source code is compiled.</li>
          <li>A lot of SDKs, so easy to connect with other system.</li>
          <li>Documents, structures are available.</li>
          <li>New framework with better performance and powerful.</li>
          <li>Provide both Backend/Frontent.</li>
        </ul>
      </td>
      <td>
        <ul>
          <li>High costing.</li>
          <li>Focus on ecommerce, bloging, ...</li>
          <li>Not support dynamic module, plugin: we have to build all in one to switch on/off feature or do the new deployment with new changes.</li>
          <li>All most are commercial version</li>
          <li>Can not use free version or open source version because maintenance service.</li>
          <li>Frontent is not flexible.</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>NodeJS, Python</td>
      <td>
        <ul>
          <li>strapi.</li>
          <li>ApostropheCMS.</li>
          <li>Wagtail CMS.</li>
        </ul>
      </td>
      <td>
        <ul>
          <li>Build faster then Java, DotNET.</li>
          <li>Can compile source code.</li>
          <li>Many package and SDKs.</li>
          <li>Provide both Backend/Frontent.</li>
        </ul>
      </td>
      <td>
        <ul>
          <li>License: the source code is compiled.</li>
          <li>Dificult to create a document and maintain because they are scripting language, so we don't declare data type.</li>
          <li>Less document.</li>
          <li>Not support dynamic module, plugin (the same with java, dotnet).</li>
          <li>Frontent is not flexible.</li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>


So I can note these main reasons below:
 - License.
 - Maintain Service.
 - Easy to develop.
 - Good comunity and popular.
 - Flexible.
 - High perfomance.


## 2. My own CMS.

I provide full system. It includes both frontend, backend, database, network, secure, ...
- My system has designed for 4 years, I changed from PHP, NodeJS, DotNET and Java now.
- Develop base package only.
  - Restful APIs (Java).
  - Core UI (Angular).
  - Identity service (Keycloak).
  - Authorization Service (Open Policy Agent).
  - Distributed tracing system (Zipkin and ELK).
  - File system (NFS, S3), file browser, CDN.
  - Email/Notification service.

- Apply Kubernetes.
- Apply Kong Ingress.
- Monitoring the with many applications such as Grafana, Kibana, Konga, ...
- Kong provide a lot of plugin to improve performance, caching, monitoring, security, ...
- CI/CD with Jenkins and SonarQube.

### 2.1. Global Standard.
- I can join with almost commercial applications over the world. From my side, I can join with SAP, Blockchain system, ....
- Containerized application: We can deploy as single application or a service of my ecosystem.
- Can deploy on Google Cloud, AWS, Azure or VM/Physical System, ...
- Scalable: Disk storage (NFS, S3), Load Balancer (Kong, ELB, Nginx), Replicas (Kubernetes)
- Statefulset: (Mysql, Elasticsearch, ...)

### 2.2. Flexible.

I don't care about your Backend, Frontend language or Database.

- Just follow the same stardard (almost global stardards: JWT, OAuth, RestAPI, ...).
- Event-driven with RabbitMQ.
- Webpack module federation (Frontend).
- Depended on your programming language, you can use any databases.

### 2.3. Core.

- Java:
  - RestAPI
  - Validator
  - Security
  - Database (any Database)

- Angular:
  - Listing
  - Detail
  - Dashboard
  - All types of input: text, html, checkbox, file, ...
  - Base screen.

- Library which provides API to communicate with my other services.
- Centralized logging system is ready.
- Distributed tracing system is ready.


### 2.4. Apply microservices.

- The service can work independence, so new feature can switch on/off whenever you want.
- Easy to develop.
  - Just focus your business, because I already have Identity, Authorize and many service in my system.
  - Document, Design Pattern, System Design, ...
  - Less code.
- New services can use my sharing data such as: GADM (Global Administrative Areas), GIS (Geographic Information System), Real Estate, Company Directory, .... and many data.
- High performance. I'm not focus on any domain, just provide package as an adapter and scalable system, so you can change to your package or improve my package or scale up/down.

### 2.5. Apply micro frontend.

- My base package is using Angular Material. But the core CMS is independence, you can change to Ant design or any Core UI.
- I develop my CMS in Angular and support Webpack module federation. So you apply Webpack module federation also, you can load/import my other applications to your app. For example, you can include my news service to your application and filter them by country, province, district, ...
- My system support Service Worker by default, so the application can work offline.


### 2.6. Generate service.

- Currently, I deploy a service to read your Database design, then generate full application in 1 second, includes:
  - RestAPI to manage data.
  - Angular UI (listing, detail, chart, ...).
  - Dockerfile.
  - Yaml deployment file.
- Join my system and release in few minutes.
- Reduce mistake.


## 3. My problems.

- I learnt lots of thing from my Technical Manager and Solution Architect, then I applied for 3, 4 commercial products and my 5+ products. But I think I need more advice from anyone.
- I didn't try enough other products based on CMS.
- I didn't provide enough document.
- Operating cost at middle level ($40/month).
- Less plugins but can increase in short time.

## 4. Roadmap.

- Update UI.
