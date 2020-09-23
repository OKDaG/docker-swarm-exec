FROM ubuntu:16.04

WORKDIR /app

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
	    python-pip python-setuptools \
        curl \
        python3 \
        python3-requests \
        python3-setuptools \
        python3-pip && \
    pip3 install --upgrade pip && \
    pip3 install docker

COPY swarm-exec /app/

ENTRYPOINT [ "./swarm-exec" ]