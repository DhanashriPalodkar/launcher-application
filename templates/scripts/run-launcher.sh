#!/bin/bash

EXTRA_ARGS=

case "$1" in
    minishift)
        ;;
    keycloak)
        EXTRA_ARGS=--keycloak
        ;;
    stop)
        docker rm -f launcher-backend
        docker rm -f launcher-frontend
        exit
        ;;
    help)
        echo "Usage: run-launcher.sh [options]"
        echo ""
        echo "Runs the Launcher using Docker images from backend and frontend"
        echo ""
        echo "Options:"
        echo "   minishift         : Run the Launcher using a local minishift instance"
        echo "   keycloak          : Run the Launcher using the official Keycloak server"
        echo "   stop              : Stop any running Launcher Docker containers"
        echo "   --ghuser <user>   : Sets/overrides the GitHub user to use when running"
        echo "   --ghtoken <token> : Sets/overrides the GitHub token to use when running"
        echo "   help              : This help"
        exit
        ;;
    *)
        echo "Missing argument, should be one of: minishift, keycloak, stop or help"
        exit
        ;;
    *)
esac
shift

# Get the docker scripts to run the Launcher
mkdir -p /tmp/run-launcher
[[ ! -f /tmp/run-launcher/backend.sh ]] && wget -q -O /tmp/run-launcher/backend.sh https://raw.githubusercontent.com/fabric8-launcher/launcher-application/master/docker.sh
[[ ! -f /tmp/run-launcher/clusters.yaml ]] && wget -q -O /tmp/run-launcher/clusters.yaml https://raw.githubusercontent.com/fabric8-launcher/launcher-application/master/clusters.yaml

# Make sure the docker image is up-to-date
docker pull fabric8/launcher-backend

# Run the Launcher application
bash /tmp/run-launcher/backend.sh -td --run --net $EXTRA_ARGS "$@"  

# Open the Launcher in a browser
xdg-open http://localhost:8088

