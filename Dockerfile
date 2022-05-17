FROM ubuntu

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update &&\
    apt install -y python3 python3-pip \
    firefox-geckodriver python3-virtualenv libpci-dev libegl*

#############################@###########################################
RUN addgroup --system xusers \
  && adduser \
			--home /home/xuser \
			--disabled-password \
			--shell /bin/bash \
			--gecos "user for running X Window stuff" \
			--ingroup xusers \
			--quiet \
			xuser

# Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update && apt-get install -y --no-install-recommends \
				xvfb \
				xauth \
				x11vnc \
				x11-utils \
				x11-xserver-utils \
		&& rm -rf /var/lib/apt/lists/*

# create or use the volume depending on how container is run
# ensure that server and client can access the cookie
RUN mkdir -p /Xauthority && chown -R xuser:xusers /Xauthority
VOLUME /Xauthority

# start x11vnc and expose its port
ENV DISPLAY :0.0
EXPOSE 5900
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# switch to user and start
#USER xuser

########################################################################

WORKDIR /opt/firefox
COPY . /opt/firefox/

RUN virtualenv env &&\
    pip3 install -r requirements.txt &&\
    chmod +x /opt/firefox/env/bin/activate

RUN echo 'source /opt/firefox/env/bin/activate' >> ~/.bashrc

ENTRYPOINT [ "/entrypoint.sh" ]