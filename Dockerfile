FROM alpine

LABEL "name"="GPG Builder"
LABEL "description"=""
LABEL "maintainer"="v77 Development <mail@v77.dev>"
LABEL "repository"="https://github.com/ghastore/build-gpg.git"
LABEL "homepage"="https://github.com/ghastore"

COPY *.sh /
RUN apk add --no-cache bash curl git git-lfs gpg

ENTRYPOINT ["/entrypoint.sh"]
