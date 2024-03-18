FROM registry.access.redhat.com/ubi9/ubi

RUN dnf install --assumeyes git patch python3-pip \
  && dnf clean all \
  && rm --recursive --force /var/cache/yum

ENV DASHBOARD_USER=""
ENV DASHBOARD_PASSWORD=""

COPY files/esphome_start /usr/local/bin/
COPY files/esphome-patches/tornado-enable-ssl.patch /usr/local/src/

RUN groupadd esphome --gid 1000 \
 && useradd esphome --uid 1000 --gid esphome --home-dir /etc/esphome

RUN mkdir --parents /etc/esphome \
 && chown --recursive esphome: /etc/esphome

USER esphome

RUN python3 -m pip install --no-warn-script-location --user --upgrade pip \
 && python3 -m pip install --no-warn-script-location --user esphome

RUN git config --global advice.detachedHead false

EXPOSE 6052

VOLUME ["/etc/esphome"]

CMD ["esphome_start"]
