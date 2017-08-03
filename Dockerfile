FROM postgres:9.6-alpine

ADD repos.txt /tmp/

RUN cat /tmp/repos.txt >> /etc/apk/repositories && \
    rm /tmp/repos.txt && \
    apk --update --upgrade add supervisor gosu@testing

ENV \
  POSTGRES_PASSWORD=changeme \
  BARMAN_USER=barman \
  BARMAN_PASSWORD=bigsecret \
  BARMAN_SLOT_NAME=barman \
  STREAMING_USER=streaming_barman \
  STREAMING_PASSWORD=unguessable \
  PGDATA=/pgdata

VOLUME $PGDATA

ADD docker-entrypoint.sh /
ADD supervisord.conf /etc/
COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY image-pre-start.d /image-pre-start.d
COPY functions.sh /usr/local/bin/

RUN chmod +x /docker-entrypoint.sh && \
    mkdir -p /var/log/supervisor/postgres && \
    mkdir -p /var/run && chmod 775 /var/run && \
    chown -R postgres:postgres $PGDATA /var/log/supervisor/postgres && \
    chmod +x /image-pre-start.d/*.sh

EXPOSE 5432

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
