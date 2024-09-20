import requests
import json

# Define the API endpoint
url = 'http://notifications-service:3000/api/notify'

# Define the headers
headers = {
    'accept': 'text/plain; charset=utf-8',
    'Content-Type': 'application/json; charset=utf-8'
}

# Define the data payload (in JSON format)
payload = {
    "notification_type": "OutOfRange",
    "researcher": "d.landau@uu.nl",
    "measurement_id": "1234",
    "experiment_id": "5678",
    "cipher_data": "D5qnEHeIrTYmLwYX.hSZNb3xxQ9MtGhRP7E52yv2seWo4tUxYe28ATJVHUi0J++SFyfq5LQc0sTmiS4ILiM0/YsPHgp5fQKuRuuHLSyLA1WR9YIRS6nYrokZ68u4OLC4j26JW/QpiGmAydGKPIvV2ImD8t1NOUrejbnp/cmbMDUKO1hbXGPfD7oTvvk6JQVBAxSPVB96jDv7C4sGTmuEDZPoIpojcTBFP2xA"
}

# Send the POST request
response = requests.post(url, headers=headers, json=payload)

# Check if the request was successful
if response.status_code == 200:
    latency = response.text
    print("Success! Server Response:")
    print(latency)  # Print the response from the server (expected latency)
    with open('/usr/src/latency_logs/log.txt', 'a') as f: # Write to file or create file if doesn't exist
        f.write(f"{latency}\n")
else:
    print(f"Failed to send request. Status code: {response.status_code}")
    print(response.text)  # Print the error response from the server
