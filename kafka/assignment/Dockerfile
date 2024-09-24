FROM python:3.8

WORKDIR /usr/src/app

COPY ./requirements.txt ./
RUN pip install -r requirements.txt

COPY ./*.py ./

# Copy the schemas directory into the working directory
COPY ./schemas ./schemas

VOLUME ["/usr/src/app/auth"]

ENTRYPOINT ["python3", "-u", "deserializer.py"]
