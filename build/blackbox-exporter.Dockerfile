FROM prom/blackbox-exporter:latest as bbe

FROM alpine:latest
RUN apk update && apk add libcap
COPY --from=bbe /bin/blackbox_exporter /bin/blackbox_exporter
COPY --from=bbe /etc/blackbox_exporter/config.yml /etc/blackbox_exporter/config.yml
RUN setcap cap_net_raw+ep /bin/blackbox_exporter

EXPOSE      9115
ENTRYPOINT  [ "/bin/blackbox_exporter" ]
CMD         [ "--config.file=/etc/blackbox_exporter/config.yml" ]