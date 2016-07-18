FROM ubuntu:15.10

# Locale
RUN locale-gen ja_JP.UTF-8 en_US.UTF-8

# Update Apt Packages
RUN apt-get update
RUN apt-get -qqy --force-yes dist-upgrade

# Add Oracle Java Repo
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
  && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# Install Apt Packages
RUN apt-get update && apt-get install -y \
  ca-certificates \
  locales \
  oracle-java8-installer \
  oracle-java8-set-default \
  unzip \
  curl \
  ffmpeg \
  lame

# Get Subsonic stand-alone package
ENV SUBSONIC_HOME /var/subsonic
ENV PKG_VER 6.0

RUN mkdir ${SUBSONIC_HOME}
RUN curl http://subsonic.org/download/subsonic-${PKG_VER}-standalone.tar.gz \
  | tar zx -C ${SUBSONIC_HOME}/

# Mount external volume
VOLUME /mnt/media

# Expose http
EXPOSE 4040

# Entry point
ENTRYPOINT ["${SUBSONIC_HOME}/standalone/subsonic.sh"]
