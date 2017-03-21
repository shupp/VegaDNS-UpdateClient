FROM ubuntu:xenial

RUN apt-get update && apt-get install -y dbndns runit wget python python-pip
RUN pip install redis

ADD update-data.sh /etc/update-data.sh
ADD tinydns-run.sh /etc/service/tinydns/run
ADD redis_listener.sh /etc/service/redis_listener/run

ENV ROOT="/etc/tinydns" IP="0.0.0.0" UID="0" GID="0" PYTHONUNBUFFERED="1"
RUN mkdir -p $ROOT
EXPOSE 53/udp

CMD ["runsvdir", "/etc/service"]
