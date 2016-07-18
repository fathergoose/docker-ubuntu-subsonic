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
ENV SUBSONIC_TRANSCODE_FOLDER ${SUBSONIC_HOME}/transcode
ENV SUBSONIC_MUSIC_FOLDER /mnt/media/Music
ENV SUBSONIC_PODCAST_FOLDER /mnt/media/Podcast
ENV SUBSONIC_PLAYLIST_FOLDER /mnt/media/Playlists
VOLUME ${SUBSONIC_TRANSCODE_FOLDER}
VOLUME ${SUBSONIC_MUSIC_FOLDER}
VOLUME ${SUBSONIC_PODCAST_FOLDER}
VOLUME ${SUBSONIC_PLAYLIST_FOLDER}

# Expose http
EXPOSE 4040

# Entry point
ENTRYPOINT ${SUBSONIC_HOME}/standalone/subsonic.sh
CMD [ \
  "--default-music-folder=${SUBSONIC_MUSIC_FOLDER}", \
  "--default-podcast-folder=${SUBSONIC_PODCAST_FOLDER}", \
  "--default-playlist-folder=${SUBSONIC_PLAYLIST_FOLDER}" \
]
