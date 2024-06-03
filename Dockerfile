FROM debian:bookworm as build

RUN (apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y gcc make autoconf automake gettext git \
    python3-cherrypy3 python3-cheetah python3-libvirt \
    python3-pil python3-configobj \
    python3-pam python3-m2crypto python3-jsonschema \
    qemu-kvm libtool python3-psutil python3-ethtool \
    sosreport python3-ldap \
    python3-lxml nfs-common open-iscsi lvm2 xsltproc \
    python3-parted nginx python3-guestfs libguestfs-tools \
    websockify novnc spice-html5)

RUN (git clone https://github.com/kimchi-project/kimchi.git &&\
  cd kimchi &&\
  ./autogen.sh --system &&\
  make &&\
  make install &&\
  cd / )

RUN (DEBIAN_FRONTEND=noninteractive apt-get remove -y gcc make autoconf automake git && apt-get autoremove)

# Stage 2 - Remove packages for building, copy built project
FROM debian:bookworm as build2
RUN (DEBIAN_FRONTEND=noninteractive apt-get install -y python3-configobj python3-lxml \
  python3-magic python3-paramiko python3-ldap spice-html5 novnc qemu-kvm python3-libvirt\
  python3-parted python3-ethtool python3-guestfs python3-pil python3-cherrypy3 libvirt0 \
  libvirt-daemon-system libvirt-clients nfs-common sosreport open-iscsi libguestfs-tools libnl-route-3-dev)
  
RUN (pip3 install -r requirements-UBUNTU.txt)
COPY --from=build /kimchi /kimchi
RUN (cd /kimchi && make install && cd / && rm -rf /var/lib/kimchi/isos /kimchi)

# Stage 3 - Copy file files into a flattened image
FROM scratch
COPY --from=build / /
ENTRYPOINT ["kimchid"]
CMD ["--host=0.0.0.0"]
