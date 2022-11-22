#!/bin/bash

# Build image
docker build -t nodejs-websocket:latest .

# Load image into kind
kind load docker-image nodejs-websocket:latest

