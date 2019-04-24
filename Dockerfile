FROM cm2network/steamcmd
LABEL maintainer="sessio@gmail.com"

ENV QLDS_ID=349090 GAMEPORT=27960 SERVERNAME="QLDS-docker" 
ENV STATS_PASSWORD="mypass" RCON_PASSWORD="mypass" 
ENV RCON_ENABLED=1 STATS_ENABLED=1 RCON_PORT=28960 REDIS_ADDRESS="redis"
ENV QLX_OWNER=6969 

# Install tools
USER root
RUN set -x && apt-get update && apt-get -y install python3 python3-dev git

USER steam
WORKDIR /home/steam

# Run Steamcmd and install qlds
RUN set -x \
	&& steamcmd/steamcmd.sh \
		+login anonymous \
		+force_install_dir /home/steam/qlds \
		+app_update $QLDS_ID validate \
		+quit

# Drop minqlx to qlds folder
USER steam
RUN set -x && \
	wget https://github.com/MinoMino/minqlx/releases/download/v0.5.2/minqlx_v0.5.2.tar.gz -O minqlx.tar.gz && \
	tar xzf minqlx.tar.gz -C qlds

# Clone plugins at /home/steam/minqlx-plugins
RUN set -x && \
	git clone https://github.com/MinoMino/minqlx-plugins.git && \
	wget https://bootstrap.pypa.io/get-pip.py

USER root
RUN set -x && \
	python3 get-pip.py && \
	rm get-pip.py && \
	apt-get -y install build-essential && \
	python3 -m pip install -r minqlx-plugins/requirements.txt

USER steam

VOLUME /home/steam/qlds

# set entrypoint; update qlds & run server
#ENTRYPOINT ./home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/qlds +app_update $QLDS_ID +quit && \

WORKDIR /home/steam/qlds

# run minqlx
ENTRYPOINT pwd && \
	exec /home/steam/qlds/run_server_x64_minqlx.sh \
	+set net_strict 1 \
	+set net_port $GAMEPORT \
	+set sv_hostname "$SERVERNAME" \
	+set fs_homepath /home/steam/server \
	+set zmq_rcon_enable $RCON_ENABLED \
	+set zmq_rcon_password "$RCON_PASSWORD" \
	+set zmq_rcon_port $RCON_PORT \
	+set zmq_stats_enable $STATS_ENABLED \
	+set zmq_stats_password "$STATS_PASSWORD" \
	+set zmq_stats_port $GAMEPORT \
	+set qlx_pluginsPath /home/steam/minqlx-plugins \
	+set qlx_owner $QLX_OWNER \
	+set qlx_redisAddress $REDIS_ADDRESS

# Expose ports
EXPOSE 27960 28960
