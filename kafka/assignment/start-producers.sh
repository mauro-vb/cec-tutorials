#!/bin/bash

set -e

# Default value for repetitions
repeat=3

# Parse the input arguments
while getopts "n:" opt; do
  case ${opt} in
    n ) # Set the number of repetitions
      repeat=$OPTARG
      ;;
    \? ) echo "Usage: cmd [-n number_of_repetitions]"
      exit 1
      ;;
  esac
done

# Define usage guide
USAGE="
Usage: start-producer.sh <auth-dir> <topic> <brokers> [--other-options]

    auth-dir: The path to the authentication credentials directory.
    topic: The Kafka topic to produce messages to.
    brokers: Comma-separated list of Kafka brokers.
    --other-options: Additional options passed to the experiment-producer.
"

# Check if at least 3 arguments are provided
if (( $# < 3 )); then
    echo "$USAGE"
    exit 1
fi

# Assign the first three arguments
auth="$1"; shift
topic="$1"; shift
brokers="$1"; shift

# Check if auth directory exists
if ! [[ -d "$auth" ]]; then
    echo "'$auth' is not a directory. It should be a credentials directory"
    exit 1
fi

# Start three instances of the producer concurrently
for ((i=1; i<=repeat; i++)); do
    echo "Starting experiment-producer instance $i..."
    
    docker run \
        --rm \
        -v "$(realpath $auth)":/app/experiment-producer/auth \
        dclandau/cec-experiment-producer \
        --topic "$topic" --brokers "$brokers" "$@" &

done

# Wait for all background jobs (producers) to finish
wait

echo "All producers have been started."
