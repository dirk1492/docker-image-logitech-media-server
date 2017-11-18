FROM arm32v7/debian:jessie-slim

ENV SQUEEZE_VOL /srv/squeezebox
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV PACKAGE_VERSION_URL=http://www.mysqueezebox.com/update/?version=7.9.1&revision=1&geturl=1&os=deb

RUN apt-get update && apt-get -y --no-install-recommends upgrade && \
	apt-get -y --no-install-recommends --force-yes  install sudo curl faad flac lame sox libio-socket-ssl-perl wget pv && \
        adduser --system --disabled-login --uid=2000 squeezeboxserver && \
	url=$(curl "$PACKAGE_VERSION_URL" | sed 's/_all\.deb/_arm\.deb/') && \
	echo "Install $url..." && \
	curl -Lsf -o /tmp/logitechmediaserver.deb $url && \
	dpkg -i /tmp/logitechmediaserver.deb && \
	rm -f /tmp/logitechmediaserver.deb && \
        cd /usr/share/squeezeboxserver/CPAN/arch && rm -rf 5.10 5.12 5.14 5.16 5.18 5.22 5.24 5.8 && \
        mkdir $SQUEEZE_VOL && \
        chown squeezeboxserver $SQUEEZE_VOL && \
	chgrp nogroup $SQUEEZE_VOL && \
	apt-get -y autoremove && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

VOLUME $SQUEEZE_VOL
EXPOSE 3483 3483/udp 9000 9090

COPY entrypoint.sh /entrypoint.sh
COPY start-squeezebox.sh /start-squeezebox.sh
RUN chmod 755 /entrypoint.sh /start-squeezebox.sh

USER squeezeboxserver

ENTRYPOINT ["/entrypoint.sh"]
CMD ["lms"]
