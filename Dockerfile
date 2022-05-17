FROM ubuntu

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update &&\
    apt install -y python3 python3-pip \
    firefox-geckodriver python3-virtualenv libpci-dev libegl*

WORKDIR /opt/firefox
COPY . /opt/firefox/

RUN virtualenv env &&\
    chmod +x /opt/firefox/env/bin/activate &&\
	source /opt/firefox/env/bin/activate &&\
	pip3 install -r requirements.txt

RUN echo 'source /opt/firefox/env/bin/activate' >> ~/.bashrc

COPY ./app /opt/app

ENTRYPOINT [ "python3", "/opt/app/conf.py" ]