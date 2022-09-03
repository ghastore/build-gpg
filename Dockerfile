FROM alpine

LABEL "name"="GPG Builder"
LABEL "description"=""
LABEL "maintainer"="z17 CX <mail@z17.cx>"
LABEL "repository"="https://github.com/ghastore/gpgstore-gpg-build.git"
LABEL "homepage"="https://github.com/ghastore"

COPY *.sh /
RUN apk add --no-cache bash git git-lfs gpg

ENTRYPOINT ["/entrypoint.sh"]
