repeat=1

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

# Loop to run the command multiple times
for ((i=1; i<=repeat; i++)); do
  echo "Running shortlived contaienr query iteration $i/$repeat"
  docker run --rm --network notifications-network --volume $data/latency_logs:/usr/src/latency_logs shortlived-notification-client
done
