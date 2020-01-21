FROM ubuntu

RUN apt-get update && apt-get install -y \
    rsync \
    bash \
    openssh-client

COPY entrypoint /entrypoint
RUN chmod ug+x /entrypoint

COPY test /test
RUN chmod ug+rwX /test

RUN chmod g+=rw /etc/passwd
USER 1001
ENTRYPOINT [ "/entrypoint" ]
