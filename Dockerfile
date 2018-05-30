FROM ubuntu:xenial

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get install -y dbndns runit wget unzip \
    && wget -q https://releases.hashicorp.com/consul-template/0.19.4/consul-template_0.19.4_linux_amd64.tgz \
    && tar -xvzf consul-template_0.19.4_linux_amd64.tgz \
    && rm consul-template_0.19.4_linux_amd64.tgz \
    && mv consul-template /usr/local/bin/ \
    && wget -q https://releases.hashicorp.com/consul/1.1.0/consul_1.1.0_linux_amd64.zip \
    && unzip consul_1.1.0_linux_amd64.zip \
    && rm -f consul_1.1.0_linux_amd64.zip \
    && apt-get purge -y --auto-remove unzip \
    && mv consul /usr/local/bin/

ADD update-data.sh /etc/update-data.sh
ADD tinydns-run.sh /etc/service/tinydns/run
ADD consul-template.in.tpl /etc/consul-template.in.tpl
ADD consul-template-real-time.sh /etc/service/consul-template-real-time/run
ADD consul-lock-periodic.sh /etc/service/consul-lock-periodic/run
ADD consul-lock-update-data.sh /etc/consul-lock-update-data.sh
ADD entrypoint.sh /entrypoint.sh

ENV ROOT="/etc/tinydns" IP="0.0.0.0" UID="0" GID="0"
RUN mkdir -p $ROOT
EXPOSE 53/udp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["runsvdir", "/etc/service"]
