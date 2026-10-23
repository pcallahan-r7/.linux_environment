#!/bin/bash

cpath() {
    greadlink -nf $1 | tee >(pbcopy)
    echo
}

findx() {
    find "$1" -name "$2" 2>&1 >files_and_folders | grep -v 'Permission denied' >&2
}

zipclean() {
    command zip "$@" \
        -x '.DS_Store' '*/.DS_Store' \
           '__MACOSX' '__MACOSX/*' \
           '*/__MACOSX' '*/__MACOSX/*'
}

nukenoneimages() {
    docker rmi -f "$(docker images | grep '<none>' | awk '{print $3}' | grep -v CONTAINER)"
}

nukematchingimages() {
    docker rmi -f "$(docker images | grep "$1" | awk '{print $3}' | grep -v CONTAINER)"
}

nukematchingcontainers() {
    docker rm -f "$(docker ps -a | grep "$1" | awk '{print $1}' | grep -v CONTAINER)"
}

nukevolumes() {
    docker volume rm "$(docker volume ls -q)"
}

getpod() {
    local pattern=$1
    kubectl get pods | grep "$1" | head -1 | awk '{print $1}'
}

podforward() {
    local pattern=$1
    local localport=${2:-8080}
    local remoteport=${3:-8080}
    local pod
    pod=$(getpod $pattern)
    echo "forwarding localhost:${localport} to ${pod}:${remoteport}"
    nohup kubectl --namespace default port-forward $pod ${localport}:${remoteport} &
}

rebuild-service() {
  local service=$1
  docker-compose stop $service
  docker-compose rm -f $service
  make up-${service} DETACH=true
}
