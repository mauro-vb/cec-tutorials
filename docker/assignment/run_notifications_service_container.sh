#!/bin/bash

docker run \
    --rm -d \
    --name notifications-service \
    -p 3000:3000 \
    --network notifications-network \
    dclandau/cec-notifications-service "$@"
