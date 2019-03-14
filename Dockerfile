FROM alpine

RUN apk add rsync bash openssh-client

COPY run /entrypoint
RUN chmod ug+x /entrypoint

COPY test /test
RUN chmod ug+rwX /test

USER 1001
ENTRYPOINT [ "/entrypoint" ]
