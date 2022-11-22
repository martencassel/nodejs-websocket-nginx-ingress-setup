#!/bin/bash

kind delete cluster||true
kind create cluster --config=kind-cluster-config.yaml --image kindest/node:v1.24.0


