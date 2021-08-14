# building the images with 2 tags latest and git sha for reference and debugging purpose
docker build -t goahead19/multi-client-k8s:latest -t goahead19/multi-client-k8s:$SHA -f ./client/Dockerfile ./client
docker build -t goahead19/multi-server-k8s-pgfix:latest -t goahead19/multi-server-k8s-pgfix:$SHA -f ./server/Dockerfile ./server
docker build -t goahead19/multi-worker-k8s:latest -t goahead19/multi-worker-k8s:$SHA -f ./worker/Dockerfile ./worker

# pushing images to docker hub
docker push goahead19/multi-client-k8s:latest
docker push goahead19/multi-server-k8s-pgfix:latest
docker push goahead19/multi-worker-k8s:latest

docker push goahead19/multi-client-k8s:$SHA
docker push goahead19/multi-server-k8s-pgfix:$SHA
docker push goahead19/multi-worker-k8s:$SHA

# applying kubernetes config files in the k8s folder
kubectl apply -f k8s
# updating docker images used to the latest git sha deployed
# kubectl set image <object-type>/deployment-name(from deploymnent yaml >metadata/name) 
# -suite-- <container-name>(from dployment yaml file >spec/spec/containers/name)=dockerhubname/dockerimage
kubectl set image deployments/server-deployment server=goahead19/multi-server-k8s-pgfix:$SHA
kubectl set image deployments/client-deployment client=goahead19/multi-client-k8s:$SHA
kubectl set image deployments/worker-deployment worker=goahead19/multi-worker-k8s:$SHA

# all images has been updated