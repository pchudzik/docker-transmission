FROM debian:jessie

# set any UID and GUID for the transmission user. You should pass it while building image
ARG UID=2000
ARG GUID=2000

RUN echo "Europe/Warsaw" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata && \
	apt-get update -q=2 && \
	apt-get install -q=2 -y transmission-daemon && \
	tr_dir="/var/lib/transmission-daemon" && \
	rm "$tr_dir/info" && \
	rm -rf "$tr_dir/.config/" && \
	ln -s /downloads "$tr_dir/downloads" && \
	ln -s /incomplete "$tr_dir/incomplete" && \
	ln -s /watch "$tr_dir/watch" && \
	ln -s /info "$tr_dir/info"

# modify permissions to shared folders which will allow for transmission user to rw in them
RUN usermod -u $UID debian-transmission && \
	groupmod -g $GUID debian-transmission && \
	mkdir /downloads && \
	mkdir /incomplete && \
	mkdir /logs && \
	mkdir /info && \
	mkdir /watch && \
	chown -R debian-transmission:debian-transmission /downloads && \
	chown -R debian-transmission:debian-transmission /incomplete && \
	chown -R debian-transmission:debian-transmission /info && \
	chown -R debian-transmission:debian-transmission /logs && \
	chown -R debian-transmission:debian-transmission /watch

VOLUME ["/downloads", "/incomplete", "/logs", "/info", "/watch"]

EXPOSE 9091 51413

USER debian-transmission
ENTRYPOINT ["/usr/bin/transmission-daemon", "-f", "--logfile=/logs/transmission.log", "--config-dir=/var/lib/transmission-daemon/info"]
