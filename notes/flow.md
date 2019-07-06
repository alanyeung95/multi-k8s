# Development & configuration
yaml
PVC
environment
secret

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
# Ingress load balancer

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

# Helm
## install ingress










# Anything? 
cancel the google cloud bill then activate again? May need to update the service key?
