#!/bin/bash

set -e 

cd /tmp/kustomize/huawei-dev-deploy

curl -sfLo kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v3.1.0/kustomize_3.1.0_linux_amd64

chmod u+x ./kustomize

#Remove kubeconfig folder if it exists
rm -rf /tmp/kubeconfig

#Create kubeconfig folder
mkdir /tmp/kubeconfig
cp -rf -Rvn ~/.kube/config_noncba.yml  /tmp/kubeconfig/config.yml
export KUBECONFIG="/tmp/kubeconfig/config.yml"
kubectl config use-context $CONTEXT
./kustomize edit set image REGISTRY/PROJECT_ID/IMAGE=$SWR_REGISTRY/$SWR_ORGANIZATION/$IMAGE:$GITHUB_SHA
./kustomize edit set image REGISTRY/PROJECT_ID/SUBIMAGE=$SWR_REGISTRY/$SWR_ORGANIZATION/$SUBIMAGE:$GITHUB_SHA
kubectl apply -k .
kubectl rollout status deployment/$DEPLOYMENT_NAME --namespace noncba
kubectl get services -o wide
rm -rf /tmp/kustomize/Deploy.yaml
rm -rf /tmp/kustomize/kustomization.yaml
rm -rf /tmp/run-deploy.sh
rm -rf /tmp/kubeconfig