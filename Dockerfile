FROM alpine:3.15 as source

RUN apk add --no-cache --no-progress \
    git \
    bash \
    su-exec \
    tzdata

ARG SHA
RUN git clone --branch py3 --depth=1 https://github.com/HelloZeroNet/ZeroNet.git /app/

WORKDIR /app

#------------------#

FROM alpine:3.15

# Original Credit - "Sandro Jäckel <sandro.jaeckel@gmail.com>"
LABEL maintainer="Chris Bensch <chris.bensch@gmail.com>" \
  org.opencontainers.image.description="ZeroNet - Decentralized websites using Bitcoin crypto and BitTorrent network"

RUN export user=zeronet \
  && addgroup -S $user && adduser -D -S -G $user $user

RUN apk add --no-cache --no-progress \
    openssl \
    py3-pip \
    tor \
    bash \
    su-exec \
    tzdata

RUN pip3 install --upgrade pip

COPY [ "files/pip.conf", "/etc/" ]
COPY [ "files/entrypoint.sh", "/usr/local/bin/" ]
COPY [ "files/run.sh", "/usr/local/bin/" ]
COPY --from=source [ "/app", "/app" ]

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN pip3 install --no-cache-dir --progress-bar off -r /app/requirements.txt \
  #&& mv /app/plugins/disabled-UiPassword /app/plugins/UiPassword \
  && echo "ControlPort 9051" >>/etc/tor/torrc \
  && echo "CookieAuthentication 1" >>/etc/tor/torrc

VOLUME /app/data
WORKDIR /app
EXPOSE 43110 26552
ENV HOME=/app \
  ENABLE_TOR=false
ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "run.sh" ]
