#!/bin/bash

# Default brokers
DEFAULT_BROKERS="13.60.146.188:19093,13.60.146.188:29093,13.60.146.188:39093"

# Usage information
usage() {
    echo "Usage: $0 <auth> <topic> [brokers]"
    echo "  auth: Path to the authentication directory with credentials."
    echo "  topic: The Kafka topic to consume messages from."
    echo "  brokers: (optional) Kafka broker <ip>:<port>. Default: $DEFAULT_BROKERS"
    exit 1
}

# Check minimum arguments
if [ $# -lt 2 ]; then
    usage
fi

auth="$1"
topic="$2"
brokers="${3:-$DEFAULT_BROKERS}"  # Use provided brokers or default

# Verify the auth directory
if [ ! -d "$auth" ]; then
    echo "'$auth' is not a directory. It should contain the necessary credentials."
    exit 1
fi

# Prepare and run the Docker command
docker_command="docker run --rm -v \"$(realpath "$auth")\":/usr/src/auth simple-deserializer \"$topic\" \"$brokers\""

# Execute the Docker command
eval "$docker_command"
