FROM debian:buster-slim

ENV SQUEEZE_VOL /srv/squeezebox
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ARG PACKAGE_VERSION_URL=http://www.mysqueezebox.com/update/?version=7.9.1&revision=1&geturl=1&os=deb
ENV PACKAGE ""

RUN apt-get update && apt-get -y --no-install-recommends upgrade && \
 	apt-get -y --no-install-recommends install sudo curl faad flac lame sox libio-socket-ssl-perl wget pv iproute2 ca-certificates && \
 	adduser --system --disabled-login --uid=2000 squeezeboxserver && \
    case `arch` in \
	arm*) \
		PACKAGE=$(curl "$PACKAGE_VERSION_URL" | sed 's/_all\.deb/_arm\.deb/') \
		;; \
	*) \
		PACKAGE=$(curl "$PACKAGE_VERSION_URL" | sed 's/_all\.deb/_amd64\.deb/') \
		;; \
	esac ; \ 
 	echo "Install $PACKAGE..." && \
 	curl -Lsf -o /tmp/logitechmediaserver.deb $PACKAGE && \
 	dpkg -i /tmp/logitechmediaserver.deb && \
 	rm -f /tmp/logitechmediaserver.deb && \
         cd /usr/share/squeezeboxserver/CPAN/arch && rm -rf 5.20 5.26 5.30 && \
         mkdir $SQUEEZE_VOL && \
         chown squeezeboxserver $SQUEEZE_VOL && \
 	chgrp nogroup $SQUEEZE_VOL && \
 	apt-get -y autoremove && \
 	apt-get clean && rm -rf /var/lib/apt/lists/*

 VOLUME $SQUEEZE_VOL
 EXPOSE 3483 3483/udp 9000 9090 49152-49162 

 COPY entrypoint.sh /entrypoint.sh
 COPY start-squeezebox.sh /start-squeezebox.sh
 RUN chmod 755 /entrypoint.sh /start-squeezebox.sh

 USER squeezeboxserver

 ENTRYPOINT ["/entrypoint.sh"]
 CMD ["lms"]
