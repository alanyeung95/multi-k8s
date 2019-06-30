docker build -t alanyeung95/multi-client:latest -t alanyeung95/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t alanyeung95/multi-server:latest -t alanyeung95/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t alanyeung95/multi-worker:latest -t alanyeung95/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker push alanyeung95/multi-cilent:latest
docker push alanyeung95/multi-server:latest
docker push alanyeung95/multi-worker:latest
docker push alanyeung95/multi-cilent:$SHA
docker push alanyeung95/multi-server:$SHA
docker push alanyeung95/multi-worker:$SHA
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=alanyeung95/multi-server:$SHA
kubectl set image deployments/client-deployment client=alanyeung95/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=alanyeung95/multi-worker:$SHA
