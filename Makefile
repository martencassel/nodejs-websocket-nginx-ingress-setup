
.PHONY: kubectl-create-dapr-deployment
kubectl-create-dapr-deployment: docker dapr-init-k8s append_etc_hosts_ingress_hostname
	kubectl wait --for=condition=ready pod -l app=nginx-ingress-nginx-ingress --timeout=60s
	kubectl wait -n=dapr-system --for=condition=ready pod -l app.kubernetes.io/part-of=dapr --timeout=60s
	./scripts/kubectl-install-dapr-deployment.sh

open-browser-client:
	google-chrome ./www/index.html &

append_etc_hosts_ingress_hostname:
	cd ./scripts && ./append_etc_hosts_ingress_hostname.sh

kind-create-cluster:
	cd ./scripts && ./kind-create-cluster.sh
	kubectl wait --for=condition=Ready nodes --all --timeout=600s

dapr-init-k8s: 
	dapr init --kubernetes
	kubectl wait -n=dapr-system --for=condition=ready pod -l app.kubernetes.io/part-of=dapr --timeout=60s

helm-install-ingress-nginx-kind: kind-create-cluster
	kubectl wait --for=condition=Ready nodes --all --timeout=600s
	cd ./scripts && ./helm-install-ingress-nginx-kind.sh
	sleep 10
	kubectl wait --for=condition=ready pod -l app=nginx-ingress-nginx-ingress --timeout=60s
	sleep 10
	curl -v http://localhost:30001
	curl -v -k https://localhost:30002

docker: kind-create-cluster helm-install-ingress-nginx-kind
	./scripts/build_load_image.sh

test-websocket-ingress:
	sleep 10
	websocat ws://nodejs-websocket.localhost:30001/ws/

run-websocat:
	websocat ws://nodejs-websocket.localhost:30001/ws/

