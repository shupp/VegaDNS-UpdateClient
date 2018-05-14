FROM ubuntu:xenial

RUN apt-get update && apt-get install -y dbndns runit wget python python-pip \
    && pip install redis \
    && apt-get purge -y --auto-remove dpkg-dev libc-dev-bin libc6-dev libexpat1-dev \
       libgcc-5-dev libpython-all-dev libpython-dev libpython2.7-dev libstdc++-5-dev \
       linux-libc-dev manpages-dev python-all-dev python-dev python2.7-dev

ADD update-data.sh /etc/update-data.sh
ADD tinydns-run.sh /etc/service/tinydns/run
ADD redis_listener.sh /etc/service/redis_listener/run

ENV ROOT="/etc/tinydns" IP="0.0.0.0" UID="0" GID="0" PYTHONUNBUFFERED="1"
RUN mkdir -p $ROOT
EXPOSE 53/udp

CMD ["runsvdir", "/etc/service"]
