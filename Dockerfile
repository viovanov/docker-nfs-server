FROM ubuntu
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && apt-get install -y nfs-kernel-server runit inotify-tools -qq
RUN mkdir -p /exports

RUN mkdir -p /etc/sv/nfs
ADD nfs.init /etc/sv/nfs/run
ADD nfs.stop /etc/sv/nfs/finish

ADD nfs_setup.sh /usr/local/bin/nfs_setup

RUN echo "rpc.nfsd 2049/tcp" >> /etc/services
RUN echo "nfs 111/udp" >> /etc/services
RUN echo "rpc.statd-bc 32765/tcp" >> /etc/services
RUN echo "rpc.statd-bc 32765/udp" >> /etc/services
RUN echo "rpc.statd 32766/tcp" >> /etc/services
RUN echo "rpc.statd 32766/udp" >> /etc/services
RUN echo "rpc.mountd 32767/tcp" >> /etc/services
RUN echo "rpc.mountd 32767/udp" >> /etc/services
RUN echo "rcp.lockd 32768/tcp" >> /etc/services
RUN echo "rcp.lockd 32768/udp" >> /etc/services
RUN echo "rpc.quotad 32769/tcp" >> /etc/services
RUN echo "rpc.quotad 32769/udp" >> /etc/services

RUN echo 'STATDOPTS="--port 32765 --outgoing-port 32766"' >>  /etc/default/nfs-common
RUN echo 'RPCMOUNTDOPTS="-p 32767"' >>  /etc/default/nfs-kernel-server
RUN echo 'RPCRQUOTADOPTS="-p 32769"' >>  /etc/default/quota
RUN mkdir -p /etc/modprobe.d/
RUN echo 'options lockd nlm_udpport=32768 nlm_tcpport=32768' >> /etc/modprobe.d/local.conf

VOLUME /exports

EXPOSE 111/udp 2049/tcp

ENTRYPOINT ["/usr/local/bin/nfs_setup"]
