FROM    minio/minio:edge

ARG GOSU_VERSION="1.10"

ADD https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 /usr/bin/gosu
RUN chmod +x /usr/bin/gosu

ADD entrypoint.sh /
RUN  chmod +x /entrypoint.sh

ENV     MINIO_USER=www-data
ENV     MINIO_GROUP=www-data
ENV     MINIO_UID=33
ENV     MINIO_HOMEDIR=/export

VOLUME      ["/export"]
CMD         ["server", "/export"]
ENTRYPOINT  ["/entrypoint.sh"]
