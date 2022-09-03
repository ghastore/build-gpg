FROM debian:stable

LABEL "name"="GPG Builder"
LABEL "description"=""
LABEL "maintainer"="z17 CX <mail@z17.cx>"
LABEL "repository"="https://github.com/ghastore/gpgstore-gpg-build.git"
LABEL "homepage"="https://github.com/ghastore"

RUN apt update && apt install --yes ca-certificates

COPY sources-list /etc/apt/sources.list
COPY *.sh /
RUN apt update && apt install --yes bash curl git git-lfs gpg tar xz-utils

ENTRYPOINT ["/entrypoint.sh"]
