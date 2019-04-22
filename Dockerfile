FROM cm2network/steamcmd
LABEL maintainer="sessio@gmail.com"

# Run Steamcmd and install qlds
RUN set -x \
	&& ./home/steam/steamcmd/steamcmd.sh \
		+login anonymous \
		+force_install_dir /home/steam/qlds \
		+app_update 349090 validate \
		+quit
	#&& cd /home/steam/qlds \ 
    	#&& wget -qO- https://raw.githubusercontent.com/CM2Walki/CSGO/master/etc/cfg.tar.gz | tar xf -

ENV GAMEPORT=27960 SERVERNAME="Quake Live Dedicated" STATS_PASSWORD="mypass"

VOLUME /home/steam/qlds

# Set Entrypoint; Technically 2 steps: 1. Update server, 2. Start server
ENTRYPOINT ./home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/qlds +app_update 349090 +quit && \
	exec /home/steam/qlds/run_server_x64.sh \
	+set net_strict 1 \
	+set net_port $GAMEPORT \
	+set sv_hostname "$SERVERNAME" \
	+set fs_homepath /home/steam/server \
	+set zmq_stats_enable 1 \
	+set zmq_stats_password "$STATS_PASSWORD" \
	+set zmq_stats_port $GAMEPORT
# Expose ports
EXPOSE 27960
