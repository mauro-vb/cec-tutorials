from confluent_kafka import Consumer
import avro.schema
from avro.io import DatumReader, BinaryDecoder
from avro.datafile import DataFileReader
import io
import os

def deserialize_message(msg):
    if msg.headers():
        byte_string = msg.headers()[0][1]
        record_name = byte_string.decode('utf-8')
        #schema = get_schema(record_name)
        #reader = DatumReader(schema)
        msg_value = msg.value()
        print(record_name)
        print(decode_avro_ocf(msg_value))
        

def get_schema(record_name: str):
    schema_path = os.path.join("schemas", f"{record_name}.avsc")
    return avro.schema.parse(open(schema_path, "rb").read())

def decode_avro_ocf(msg_value):
    # Use a BytesIO stream to handle the Avro container
    with io.BytesIO(msg_value) as message_bytes:
        # Open the Avro Object Container File
        reader = DataFileReader(message_bytes, DatumReader())
        
        # Read and return each record in the container
        records = []
        for record in reader:
            records.append(record)
        
        reader.close()
        return records

def decode(msg_value, reader):
    message_bytes = io.BytesIO(msg_value)
    decoder = BinaryDecoder(message_bytes)
   # message_bytes.seek(5)
    event_dict = reader.read(decoder)
    return event_dict


def consume_messages(topic, brokers):
    consumer = Consumer({
        'bootstrap.servers': brokers,  # Use dynamic brokers
        'group.id': 'group26',
        'auto.offset.reset': 'earliest',  # Start from the beginning
        'enable.auto.commit': 'true',
        'security.protocol': 'SSL',
        'ssl.ca.location': '/usr/src/auth/ca.crt',
        'ssl.keystore.location': '/usr/src/auth/kafka.keystore.pkcs12',
        'ssl.keystore.password': 'cc2023',
        'ssl.endpoint.identification.algorithm': 'none',
    })

    consumer.subscribe([topic])

    try:
        while True:
            msg = consumer.poll(1.0)  # Poll for messages
            if msg is None:
                continue
            if msg.error():
                print(f"Consumer error: {msg.error()}")
                continue
            deserialize_message(msg)  # Call to print deserialized message

    finally:
        consumer.close()


if __name__ == "__main__":
    import sys

    if len(sys.argv) != 3:
        print("Usage: python script.py <topic> <brokers>")
        sys.exit(1)

    topic = sys.argv[1]
    brokers = sys.argv[2]

    consume_messages(topic, brokers)
