FROM ubuntu
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && apt-get install -y nfs-kernel-server runit inotify-tools -qq
RUN mkdir -p /exports

RUN mkdir -p /etc/sv/nfs
ADD nfs.init /etc/sv/nfs/run
ADD nfs.stop /etc/sv/nfs/finish

ADD nfs_setup.sh /usr/local/bin/nfs_setup

RUN echo "nfs             2049/tcp" >> /etc/services
RUN echo "nfs             111/udp" >> /etc/services

RUN echo "RQUOTAD_PORT=875" >> /etc/sysconfig/nfs
RUN echo "LOCKD_TCPPORT=32803" >> /etc/sysconfig/nfs
RUN echo "LOCKD_UDPPORT=32769" >> /etc/sysconfig/nfs
RUN echo "MOUNTD_PORT=892" >> /etc/sysconfig/nfs
RUN echo "STATD_PORT=662" >> /etc/sysconfig/nfs

VOLUME /exports

EXPOSE 111/udp 2049/tcp

ENTRYPOINT ["/usr/local/bin/nfs_setup"]
