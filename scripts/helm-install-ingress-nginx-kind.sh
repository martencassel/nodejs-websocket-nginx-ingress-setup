#!/bin/bash

helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update

helm install nginx-ingress nginx-stable/nginx-ingress --version 0.15.1 \
	--set controller.publishService.enabled=true \
	--set controller.service.type=NodePort \
	--set controller.service.httpPort.nodePort=30001 \
	--set controller.service.httpsPort.nodePort=30002

