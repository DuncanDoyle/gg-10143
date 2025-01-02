#!/bin/sh

pushd ..

# Create namespaces if they do not yet exist
# kubectl create namespace ingress-gw --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace httpbin --dry-run=client -o yaml | kubectl apply -f -

# Deploy the HTTPBin application
printf "\nDeploy HTTPBin application ...\n"
kubectl apply -f apis/httpbin.yaml

# Deploy the AuthConfig application
printf "\nDeploy AuthConfig ...\n"
kubectl apply -f policies/apikey-authconfig.yaml

# Deploy the correct API-Key secret
printf "\Deploy correct API-Key secret ...\n"
kubectl apply -f secrets/infra-apikey-secret.yaml

# VirtualServices
printf "\nDeploy VirtualServices ...\n"
kubectl apply -f virtualservices/api-example-com-vs.yaml

popd