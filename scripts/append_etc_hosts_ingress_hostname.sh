#!/bin/bash

sudo sh -c 'echo '127.0.0.1  nodejs-websocket.localhost' >> /etc/hosts'

nslookup nodejs-websocket.localhost
