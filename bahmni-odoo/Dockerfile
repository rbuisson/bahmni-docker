FROM odoo:10.0-wait-for-it
USER root
RUN apt update \
&& apt install -y git curl iproute2 iputils-ping less nano tree unzip ca-certificates
RUN git clone https://github.com/Bahmni/odoo-modules /opt/bahmni-addons
USER odoo
COPY resources/odoo.conf /etc/odoo/odoo.conf
