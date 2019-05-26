# Ansible-Postfix-MTA
An Ansible playbook to deploy MTA with Postfix SMTP Server

[![Build Status](https://travis-ci.org/danitfk/Ansible-Postfix-MTA.svg?branch=master)](https://travis-ci.org/danitfk/Ansible-Postfix-MTA)

## What is it ?
This playbook will deploy a **Postfix** as an MTA server to sends emails from one site to another. It's already integrated with **HAProxy** to have a load balancer before a bunch of MTA Servers.

![alt Ansible playbook to deploy Postfix MTA Server](https://github.com/danitfk/Ansible-Postfix-MTA/blob/master/screenshots/Postfix-MTA.png?raw=true)

## Features:

- Supports Debian(8,9) and Ubuntu Server (14.04,16.04,18.04)
- Deploy N number (to inifinity) of MTA Server at same time
- Update configuration just once and deploy on all servers
- Sending Limitation for specific domains (such as sends only 60 emails per hour to Yahoo!)
- Supports DKIM Signature (opendkim)
- Queue Management
- Secure network access and manage UFW Firewall
- Supports Rsyslog Server
- Supports Monitoring System (Zabbix, or others)
- Print queue (Active, Deferred, All) on Port 8080 with Simple requests to server
