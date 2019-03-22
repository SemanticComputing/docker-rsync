FROM alpine

RUN apk add rsync bash openssh-client

COPY entrypoint /entrypoint
RUN chmod ug+x /entrypoint

COPY test /test
RUN chmod ug+rwX /test

RUN chmod g+=rw /etc/passwd
USER 1001
ENTRYPOINT [ "/entrypoint" ]
