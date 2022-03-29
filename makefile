SHELL := /bin/bash

VERSION := 1.0

run:
	go run main.go

service:
	docker build -f zarf/docker/dockerfile -t service-amd64:$(VERSION) --build-arg BUILD_REF=$(VERSION) --build-arg BUILD_DATE='date -u +"%Y-%m-%dT%H:%M:%SZ"' .

#running kind
KIND_CLUSTER := service-cluster

kind-up:
	kind create cluster --image kindest/node:v1.21.1 --name $(KIND_CLUSTER) --config zarf/k8s/kind/kind-config.yaml

kind-down:
	kind delete cluster --name $(KIND_CLUSTER)

kind-status:
	kubectl get nodes -o wide
	kubectl get svc -o wide
	kubectl get pods -o wide --watch --namespace=service-system

kind-load:
	kind load docker-image service-amd64:$(VERSION) --name $(KIND_CLUSTER)

kind-apply:
	kubectl apply -f zarf/k8s/base/service-pod/base-service.yaml