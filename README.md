jgowdy/docker-kimchi
===============

docker image for kimchi

This is based on the work of mbentley

To pull this image:
`docker pull ghcr.io/jgowdy/docker-kimchi:latest`
or
`FROM ghcr.io/jgowdy/docker-kimchi:latest`

Usage:
```
docker run -d --restart=always --net=host --name kimchi \
  -v /etc/passwd:/etc/passwd:ro \
  -v /etc/group:/etc/group:ro \
  -v /etc/shadow:/etc/shadow:ro \
  -v /path/to/ssl/cert:/etc/kimchi/kimchi-cert.pem:ro \
  -v /path/to/ssl/key:/etc/kimchi/kimchi-key.pem:ro \
  -v /var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock \
  -v /var/lib/libvirt:/var/lib/libvirt \
  -v /etc/libvirt:/etc/libvirt \
  -v /path/to/your/storage:/path/to/your/storage \
  ghcr.io/jgowdy/docker-kimchi:latest
```
