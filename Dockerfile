FROM alpine:latest
RUN apk update && apk add --no-cache supervisor wget unzip curl

WORKDIR /root

RUN wget -q -O /tmp/v2ray-linux-64.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip && \
    unzip -d /usr/local/v2ray /tmp/v2ray-linux-64.zip v2ray


RUN apk add nginx
RUN apk add gettext

COPY html /root/html/

COPY config.json.tp /root/
COPY nginx.template.conf /root/

ADD startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD /startup.sh


