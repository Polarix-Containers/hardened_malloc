ARG VERSION=2026030200

FROM alpine:latest

LABEL maintainer="Thien Tran contact@tommytran.io"

ARG VERSION
ARG CONFIG_NATIVE=false
ARG VARIANT=default

WORKDIR /root/hardened_malloc

ADD --keep-git-dir=true https://github.com/GrapheneOS/hardened_malloc.git#${VERSION} .
    
RUN apk -U upgrade \
    && apk --no-cache add build-base git gnupg openssh-keygen \
    && rm -rf /var/cache/apk/* \
    && wget -q https://grapheneos.org/allowed_signers -O grapheneos_allowed_signers

RUN --network=none \
    git config gpg.ssh.allowedSignersFile grapheneos_allowed_signers \
    && git verify-tag $(git describe --tags) \
    && make CONFIG_NATIVE=${CONFIG_NATIVE} VARIANT=${VARIANT} \
    && mkdir -p /install \
    && mv out/libhardened_malloc.so /install
