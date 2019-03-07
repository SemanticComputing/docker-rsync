FROM alpine

RUN apk add rsync bash

COPY run /entrypoint
RUN chmod ug+x /entrypoint

USER 1001
ENTRYPOINT [ "/entrypoint" ]
