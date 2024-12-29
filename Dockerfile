FROM debian:stretch

RUN apt update && apt install -y \
        curl \
        git \
        build-essential \
        cmake \
        jq \
        mosquitto-clients

RUN git clone https://github.com/ned-kelly/docker-voltronic-homeassistant.git

RUN cd docker-voltronic-homeassistant

ADD sources/ /opt/
ADD config/ /etc/inverter/

RUN cd /opt/inverter-cli && \
    mkdir bin && cmake . && make && mv inverter_poller bin/

HEALTHCHECK \
    --interval=30s \
    --timeout=10s \
    --start-period=1m \
    --retries=3 \
  CMD /opt/healthcheck

WORKDIR /opt
ENTRYPOINT ["/bin/bash", "/opt/inverter-mqtt/entrypoint.sh"]