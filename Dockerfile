FROM --platform=${TARGETPLATFORM} alpine:latest
ARG TARGETPLATFORM
ARG TAG
COPY v2ray.sh /root/v2ray.sh

WORKDIR /root

RUN set -ex \
    && apk add --no-cache tzdata openssl ca-certificates \
    && mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray \
    # forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/v2ray/access.log \
    && ln -sf /dev/stderr /var/log/v2ray/error.log \
    && chmod +x /root/v2ray.sh \
    && /root/v2ray.sh "${TARGETPLATFORM}" "${TAG}"


RUN apk add nginx
RUN apk add gettext

COPY html /root/html/

COPY config.json.tp /root/
COPY nginx.template.conf /root/

ADD startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD /startup.sh


