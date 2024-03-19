FROM registry.access.redhat.com/ubi9/python-311

ENV DASHBOARD_USER=""
ENV DASHBOARD_PASSWORD=""

RUN mkdir --parents \
    "${APP_ROOT}"/etc/esphome \
    "${HOME}"/.pki/esphome

COPY files/esphome_start "${APP_ROOT}"/bin/
COPY files/esphome-patches/tornado-enable-ssl.patch "${APP_ROOT}"/src/

RUN python3 -m pip install --upgrade pip \
 && python3 -m pip install esphome

RUN git config --global advice.detachedHead false

EXPOSE 6052

VOLUME ["${APP_ROOT}/etc/esphome"]

CMD ["esphome_start"]
