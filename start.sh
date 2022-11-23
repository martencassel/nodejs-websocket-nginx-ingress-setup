#!/bin/bash

dapr run --app-id k8s-binding-consumer \
         --app-port 8081 --dapr-http-port 3501 --config ./manifests/k8s_event_binding.yaml node server.js
