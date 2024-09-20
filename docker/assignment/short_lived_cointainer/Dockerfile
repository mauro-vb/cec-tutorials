FROM python:3.9-slim

# Install required packages and create necessary directories
RUN pip install requests && \
    mkdir -p /usr/src/latency_logs

# Add a Python script to handle the request
ADD send_request.py /app/send_request.py

# Declare a volume for persistent data storage
VOLUME ["/usr/src/latency_logs"]

# Set the working directory
WORKDIR /app

# Command to run the Python script
CMD ["python", "send_request.py"]

