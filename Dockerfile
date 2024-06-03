FROM debian:bookworm

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
  cd / &&\
  rm -rf /var/lib/kimchi/isos /kimchi)

RUN (sed -i "s/#create_iso_pool = true/create_iso_pool = false/g" /etc/kimchi/kimchi.conf &&\
  sed -i "s/#display_proxy_port = 64667/display_proxy_port = 64668/g" /etc/kimchi/kimchi.conf)

ENTRYPOINT ["kimchid"]
CMD ["--host=0.0.0.0"]
