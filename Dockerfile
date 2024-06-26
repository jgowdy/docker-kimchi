FROM debian:bookworm-slim as build

RUN (apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y gcc make autoconf automake gettext git \
    python3-cherrypy3 python3-cheetah python3-libvirt \
    python3-pil python3-configobj \
    python3-pam python3-m2crypto python3-jsonschema \
    qemu-kvm libtool python3-psutil python3-ethtool \
    sosreport python3-ldap \
    python3-lxml nfs-common open-iscsi lvm2 xsltproc \
    python3-parted nginx python3-guestfs libguestfs-tools \
    websockify novnc spice-html5 python3-pip)

RUN (git clone https://github.com/kimchi-project/kimchi.git)

RUN (cd /kimchi && pip3 install --break-system-packages -r requirements-UBUNTU.txt)

RUN (cd /kimchi && ./autogen.sh --system && make)

RUN (cd /kimchi && make install)


# Stage 2 - Remove packages for building, copy built project
FROM debian:bookworm-slim as build2
RUN apt-get update

#RUN (apt-get update &&\
#  DEBIAN_FRONTEND=noninteractive apt-get install -y python3-configobj python3-lxml \
#  python3-magic python3-paramiko python3-ldap spice-html5 novnc qemu-kvm python3-libvirt\
#  python3-parted python3-ethtool python3-guestfs python3-pil python3-cherrypy3 libvirt0 \
#  libvirt-daemon-system libvirt-clients nfs-common sosreport libguestfs-tools libnl-route-3-dev)

#RUN apt-get install -y locales \
#    && locale-gen en_US.UTF-8 \
#    && dpkg-reconfigure locales
    
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/* /usr/share/doc/* /usr/share/doc-base/* /var/cache/*  

COPY --from=build \
  /etc/wok \
  /usr/share/wok \
  /usr/lib/python3/dist-packages/wok \
  /etc/kimchi \
  /var/lib/kimchi \
  /usr/share/locale/en_US/LC_MESSAGES/kimchi.mo \
  /usr/share/kimchi/doc \
  /etc/wok \
  /usr/share/wok \
  /usr/lib/python3/dist-packages/wok \
  /etc/kimchi \
  /var/lib/kimchi \
  /usr/share/locale/en_US/LC_MESSAGES/kimchi.mo \
  /usr/share/kimchi/doc
  
# Stage 3 - Copy file files into a flattened image
#FROM scratch
#COPY --from=build2 / /
#ENTRYPOINT ["kimchid"]
#CMD ["--host=0.0.0.0"]
