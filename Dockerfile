FROM frolvlad/alpine-glibc:alpine-3.3_glibc-2.23

WORKDIR /opt

COPY ./new_smart_launch.sh /opt/
COPY ./factorio.crt /opt/
COPY ./crontab /opt/
COPY ./backup-save.sh /opt/

VOLUME /opt/factorio/saves /opt/factorio/mods

EXPOSE 34197/udp
EXPOSE 27015/tcp

RUN chmod +x /opt/backup-save.sh
RUN touch /var/log/cron.log
RUN crontab /opt/crontab
CMD ["./new_smart_launch.sh"]

ENV FACTORIO_AUTOSAVE_INTERVAL=2 \
    FACTORIO_AUTOSAVE_SLOTS=3 \
    FACTORIO_ALLOW_COMMANDS=false \
    FACTORIO_NO_AUTO_PAUSE=false \
    VERSION=0.14.14 \
    FACTORIO_SHA1=decd1ef34a75b309791e65bc92b164f10479753b \
    FACTORIO_WAITING=false \
    FACTORIO_MODE=normal \
    FACTORIO_SERVER_NAME=$HF_SERVER_NAME \
    FACTORIO_SERVER_DESCRIPTION="$HF_USERNAME's server hosted on hosted-factorio." \
    FACTORIO_SERVER_MAX_PLAYERS= \
    FACTORIO_SERVER_VISIBILITY= \
    FACTORIO_USER_USERNAME= \
    FACTORIO_USER_PASSWORD= \
    FACTORIO_SERVER_GAME_PASSWORD= \
    FACTORIO_SERVER_VERIFY_IDENTITY= \
    HF_USERNAME=self \
    HF_SERVER_NAME=main

RUN apk --update add bash curl py-pip && \
    curl -sSL --cacert /opt/factorio.crt https://www.factorio.com/get-download/$VERSION/headless/linux64 -o /tmp/factorio_headless_x64_$VERSION.tar.gz && \
    echo "$FACTORIO_SHA1  /tmp/factorio_headless_x64_$VERSION.tar.gz" | sha1sum -c && \
    tar xzf /tmp/factorio_headless_x64_$VERSION.tar.gz && \
    rm /tmp/factorio_headless_x64_$VERSION.tar.gz
RUN pip install awscli
