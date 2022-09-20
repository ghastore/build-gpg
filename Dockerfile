FROM alpine

LABEL "name"="GPG Builder"
LABEL "description"=""
LABEL "maintainer"="z17 Development <mail@z17.dev>"
LABEL "repository"="https://github.com/ghastore/store-gpg-build.git"
LABEL "homepage"="https://github.com/ghastore"

COPY *.sh /
RUN apk add --no-cache bash curl git git-lfs gpg

ENTRYPOINT ["/entrypoint.sh"]
