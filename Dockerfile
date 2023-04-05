FROM alpine:latest
RUN apk update && apk add --no-cache supervisor wget unzip curl

WORKDIR /root

COPY v2ray.sh /root/v2ray.sh

RUN set -ex \
    && apk add --no-cache tzdata openssl ca-certificates \
    && mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray \
    # forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/v2ray/access.log \
    && ln -sf /dev/stderr /var/log/v2ray/error.log \
    && chmod +x /root/v2ray.sh \
    && /root/v2ray.sh
    
COPY config.json.tp /root/
COPY nginx.template.conf /root/
COPY edit.sh /root/

RUN chmod +x /root/edit.sh \
    && /root/edit.sh

RUN apk add nginx
RUN apk add gettext

COPY html /root/html/



ADD startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD /startup.sh


