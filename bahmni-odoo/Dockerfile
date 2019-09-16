FROM odoo:10.0-wait-for-it
USER root
RUN apt update \
&& apt install -y git curl iproute2 iputils-ping less nano tree unzip ca-certificates
# Set to use master Bahmni Addons by default
ARG ODOO_MODULES_GIT_COMMIT=master
ARG ODOO_MODULES_GIT_URL=https://github.com/Bahmni/odoo-modules.git
RUN git clone --single-branch ${ODOO_MODULES_GIT_URL} /opt/bahmni-addons; cd /opt/bahmni-addons; git reset --hard ${ODOO_MODULES_COMMIT}
USER odoo
COPY resources/odoo.conf /etc/odoo/odoo.conf
