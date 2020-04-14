FROM ubuntu:18.04

# non interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# build args
ARG BRAND
ARG VERSION

# install packages needed by fahclient installer
RUN apt-get update && apt-get install -y bzip2 monit supervisor vim psmisc

# add files to image
COPY docker-entrypoint.sh /
COPY config.xml /etc/fahclient/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY monitrc /etc/monit/monitrc

ADD https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/${BRAND}/fahclient_${VERSION}_amd64.deb /fahclient.deb

# do not properly install package, but only retrieve binaries
RUN dpkg -x ./fahclient.deb ./deb &&\
 mv deb/usr/bin/* /usr/bin &&\
 rm -rf *.deb &&\
 rm -rf deb &&\
 chmod u+x /docker-entrypoint.sh &&\
 rm -rf /var/lib/apt/lists/* &&\
 chmod 600 /etc/monit/monitrc

# go to homedir
WORKDIR /var/lib/fahclient

EXPOSE 7396 36330

# entrypoint
ENTRYPOINT ["/docker-entrypoint.sh","--web-allow=0/0:7396", "--allow=0/0:7396"]
#CMD ["/usr/bin/supervisord"]
