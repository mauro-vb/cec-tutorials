#!/bin/bash

script=$(basename "$0")

# Default brokers
DEFAULT_BROKERS="13.60.146.188:19093,13.60.146.188:29093,13.60.146.188:39093"

USAGE="
Usage: $script <auth> <topic> [brokers] [OPTIONS]

Positional parameters:
    auth: path to authentication directory with credentials. E.g. /home/ubuntu/cec-tutorials/kafka/auth
    topic: The topic where messages are to be consumed.
    brokers: (optional) The kafka broker <ip>:<port> connection. Default: $DEFAULT_BROKERS

Options:
      --ssl
          Enable SSL for Kafka connection.
      --no-ssl
          Disable SSL for Kafka connection [default].
  -h, --help
          Print help
  -V, --version
          Print version
"

if (( $# < 2 )); then
    echo "$USAGE"
    exit 1
fi

auth="$1"; shift
topic="$1"; shift

# Use default brokers if not specified
if [[ $# -gt 0 ]]; then
    brokers="$1"; shift
else
    brokers="$DEFAULT_BROKERS"
fi

if ! [[ -d "$auth" ]]; then
    echo "'$auth' is not a directory. It should be a credentials directory"
    exit 1
fi

# Prepare the Docker command to run
docker_command="docker run --rm -v \"$(realpath "$auth")\":/usr/src/app/auth simple-deserializer \"$topic\" \"$brokers\""

# Add SSL option if specified
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --ssl) 
            docker_command+=" --ssl"
            ;;
        --no-ssl) 
            docker_command+=" --no-ssl"
            ;;
        -h|--help) 
            echo "$USAGE"
            exit 0
            ;;
        -V|--version) 
            echo "Version 1.0"
            exit 0
            ;;
        *) 
            echo "Unknown parameter: $1"
            echo "$USAGE"
            exit 1
            ;;
    esac
    shift
done

# Run the Docker command
eval "$docker_command"
