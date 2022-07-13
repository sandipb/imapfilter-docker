FROM alpine:latest

ARG IMAPFILTER_CONFIG=/config
ARG IMAPFILTER_LOGS=/logs

VOLUME ${IMAPFILTER_CONFIG}
VOLUME ${IMAPFILTER_LOGS}

ENV HOME=${IMAPFILTER_CONFIG}
WORKDIR ${IMAPFILTER_CONFIG}

RUN set -xe \
	&& addgroup --gid 2000 app \
	&& adduser --uid 2000 --disabled-password --no-create-home --ingroup app app

RUN set -xe \
	&& apk update \
	&& apk upgrade \
	&& apk add --no-cache \
		libcrypto1.1 libssl1.1 moreutils bash wget curl \
	&& apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
		imapfilter \
	&& apk del --progress --purge \
	&& rm -rf /var/cache/apk/*

USER app

COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
