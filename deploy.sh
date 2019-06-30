docker build -t alanyeung95/multi-client:latest -t alanyeung95/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t alanyeung95/multi-server:latest -t alanyeung95/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t alanyeung95/multi-worker:latest -t alanyeung95/multi-worker:$SHA -f ./worker/Dockerfile ./worker
dockedr push alanyeung95/multi-cilent:latest
dockedr push alanyeung95/multi-server:latest
dockedr push alanyeung95/multi-worker:latest
dockedr push alanyeung95/multi-cilent:$SHA
dockedr push alanyeung95/multi-server:$SHA
dockedr push alanyeung95/multi-worker:$SHA
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=alanyeung95/multi-server:$SHA
kubectl set image deployments/client-deployment client=alanyeung95/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=alanyeung95/multi-worker:$SHA
