# Introduction


In this project we have deployed a react application into a google cloud, with the kubernetes engine.

# Architecture
## React app architecture
![alt text](https://github.com/alanyeung95/multi-k8s/blob/master/diagram/reactapp.png)


### Client apps explanation
* Client: sending api, list indexes I have seen -> query server pg & query server redis
* Worker: execute Fib function, listen redis message, save the key, value {10, Fib(10)} into redis
* Server: API server, insert key/index to pg, publish key/index message to redis

## k8s app architecture
![alt text](https://github.com/alanyeung95/multi-k8s/blob/master/diagram/node.png)


# Local environment

## Minikube
We are using minikube to stimulate k8s environment in local machine

### Some minikube cmd we use in this proj
```
minikube start
minikube ip
```

## Skaffold
hot reload feature for local k8s development
inject updated file (with pre-defined file type into certain pods)
```
skaffold dev
```

# Development & configuration

## Presistent volume claim
PVs are resources in the cluster. PVCs are requests for those resources and also act as claim checks to the resource. The interaction between PVs and PVCs follows this lifecycle:


```
alanyeung1995@cloudshell:~ (multi-k8s-245207)$ kubectl get storageclass
NAME                 PROVISIONER            AGE
standard (default)   kubernetes.io/gce-pd   6d21h
```
```
alanyeung1995@cloudshell:~ (multi-k8s-245207)$ kubectl describe storageclass
Name:                  standard
IsDefaultClass:        Yes
Annotations:           storageclass.beta.kubernetes.io/is-default-class=true
Provisioner:           kubernetes.io/gce-pd
Parameters:            type=pd-standard
AllowVolumeExpansion:  <unset>
MountOptions:          <none>
ReclaimPolicy:         Delete
VolumeBindingMode:     Immediate
Events:                <none>
```
```
alanyeung1995@cloudshell:~ (multi-k8s-245207)$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                      STORAGECLASS   REASON   AGE
pvc-0e6a00c7-9b1f-11e9-a137-42010a8c0189   2Gi        RWO            Delete           Bound    default/database-persistent-volume-claim   standard                5d18h

alanyeung1995@cloudshell:~ (multi-k8s-245207)$ kubectl get pvc
NAME                               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
database-persistent-volume-claim   Bound    pvc-0e6a00c7-9b1f-11e9-a137-42010a8c0189   2Gi        RWO            standard       5d18h
```

create environment variable
```
# kubectl create secret generic pgpassword --from-literal PGPASSWORD=12345asdf
```
## Ingress load balancer
* Load-balancer can only give you get access on one set of pod (e.g. server pod)
* ingress controller can allow you access 2 or more set of pod (e.g. server, client pod)
* Interesting point, what about we put load-balance just before the ingress controller?

Use ingress nginx
https://github.com/kubernetes/ingress-nginx

Run this command to create the ingress controller pod
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
minikube addons enable ingress
```
ingress in k8s please go to helm section


# Production deployment
open Github

linking github to travis CI (auto build and deploy)

travis.yaml
set docker_username and password as env in travis

## Google cloud
greate google cloud project & billing account
install google cloud sdk (as travis will deploy apps to google cloud k8s environment)
activate google service account, get service account key which is a json file
use Travis CLI to encrypt service-account.json , either install Ruby or just use docker with Ruby pre-installed

Gloud config
```
gcloud config set project multi-k8s-245207[project_id]
gcloud config set compute/zone asia-east1-a

gcloud container clusters get-credentials multi-cluster
# show nothing
kubectl create secret generic pgpassword --from-literal PGPASSWORD=mypgpassword123
```
### before install
install google cloud sdk, as Travis will deploy latest image to google k8s 
test image, if ok, run deploy.sh

### deploy
use deploy.sh to build image, push image to docker hub, kubect apply -f k8s, kubectl set image

Gcloud kubectl create secret????? why


## Helm
### install ingress by using Helm (package manager for k8s)
```
curl -LO https://git.io/get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
```

### install tiller
``` 
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
```

### use helm
```
helm init --service-account tiller --upgrade
helm install stable/nginx-ingress --name my-nginx --set rbac.create=true
```

# HTTPS
what is cert-manager and issuer???????

## Get a domain name
![alt text](https://github.com/alanyeung95/multi-k8s/blob/master/diagram/domain.png)

## Install cert-manager
Sets up infra to respond to HTTP challenge
Gets certificate, stores it in secret
```
## IMPORTANT: you MUST install the cert-manager CRDs **before** installing the
## cert-manager Helm chart
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install   --name cert-manager   --namespace cert-manager   --version v0.8.1   jetstack/cert-manager

# verify installation
kubectl describe certificates
```

## Issuer
Object telling cert manager where to get the certificate from

## Certificate
Object describing details about the certificate that should be obtained

## update ingress config for HTTPS

## Final state 
![alt text](https://github.com/alanyeung95/multi-k8s/blob/master/diagram/deploymentunit.png)
![alt text](https://github.com/alanyeung95/multi-k8s/blob/master/diagram/gcloud_shell.png)
![alt text](https://github.com/alanyeung95/multi-k8s/blob/master/diagram/google_load-balancer.png)


# What if you want to change the HTTPS domain?
* edit k8s/certificate.yaml
* edit k8s/ingress-service.yaml

Check this commit
https://github.com/alanyeung95/multi-k8s/commit/ab6645a09fdd5899098d858751a8f4da7eefe2d9


# What if we....
## 1. Delete the project and recreate a new google cloud project
###  create project
### link to billing account
### k8s engine -> enable billing, create cluster
###  IAM & admin -> create service account, role k8s engine admin (create/delete obj)
```
docker run -it -v $(pwd):/app ruby:2.3 sh

# install travis cli install the shell
gem install travis --no-document
travis encrypt-file service-account.json -r alanyeung95/multi-k8s

# may need to update openssl config in .travis.yml as well
```
### update project id (may include compute zone as well) in .travis.yml 

### set up secret
```
kubectl create secret generic pgpassword --from-literal PGPASSWORD=12345asdf
```

### install helm and triller, then use helm

### commit git and let travis-ci deploy to google cloud!!!

## 2. Change the cluster size?
1.  make sure the **replicas** in your docker yaml file is updated
2.  you can type the following cmd in gc console if your cluster is created already
```
gcloud container clusters resize multi-cluster    --size 3
```

# Q&A
Q: why Deployment kind instead of Pod kind?
```
Deployment kind can control the ports, pod can only allow to modify images, spec.initcontainers, spec.activedeadline, spec.toleration
```

Q: Why we are using sha for docker image tagging
```
First, it help us debugging with a commit hash. Second, it is an implicit tagging for new engineer
```

Q: what is the meaning of '-it' flag in docker run cmd?
```
Docker run will default connect the stdout inside the container, if we want to input something into container, we need '-it' for stdin.
The -it instructs Docker to allocate a pseudo-TTY connected to the container’s stdin; creating an interactive bash shell in the container.
-i for stdin, stdout, stderr, -t for nice formatting
```
