FROM python:3.9.4-slim-buster
WORKDIR /ecommerce
COPY ./requirements.txt ./requirements.txt
RUN pip3 install -r requirements.txt
COPY . .
CMD flask run --host=0.0.0.0