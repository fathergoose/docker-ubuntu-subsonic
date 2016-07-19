FROM ubuntu:16.04

# Locale
RUN locale-gen ja_JP.UTF-8 en_US.UTF-8

# Update Apt Packages
RUN apt-get update && apt-get -qy upgrade

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

# Link transcoders
ENV SUBSONIC_TRANSCODE_FOLDER ${SUBSONIC_HOME}/transcode
RUN mkdir -p ${SUBSONIC_TRANSCODE_FOLDER} && \
  ln -fs /usr/bin/ffmpeg /usr/bin/lame ${SUBSONIC_TRANSCODE_FOLDER}

# Mount external volume
ENV SUBSONIC_MUSIC_FOLDER /mnt/media/Music
ENV SUBSONIC_PODCAST_FOLDER /mnt/media/Podcast
ENV SUBSONIC_PLAYLIST_FOLDER /mnt/media/Playlists
VOLUME ${SUBSONIC_MUSIC_FOLDER}
VOLUME ${SUBSONIC_PODCAST_FOLDER}
VOLUME ${SUBSONIC_PLAYLIST_FOLDER}

# Expose http
EXPOSE 4040

# Entry point
ADD ./launch_subsonic.sh /launch_subsonic.sh
RUN chmod +x  /launch_subsonic.sh

ENTRYPOINT ["/launch_subsonic.sh"]
