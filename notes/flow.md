# Development & configuration
yaml
PVC
environment
secret

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
