FROM alpine:latest

RUN apk --update add tinydns runit

ADD update-data.sh /etc/service/update-data/run
ADD tinydns-run.sh /etc/service/tinydns/run

ENV ROOT="/etc/tinydns" IP="0.0.0.0" UID="0" GID="0" CHECK_DELAY="30"
RUN mkdir -p $ROOT
EXPOSE 53/udp

CMD ["runsvdir", "/etc/service"]
