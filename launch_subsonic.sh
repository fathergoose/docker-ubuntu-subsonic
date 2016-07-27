#! /bin/sh

${SUBSONIC_HOME}/subsonic.sh --port=${SUBSONIC_PORT} --https-port=${SUBSONIC_HTTPS_PORT} --default-music-folder=${SUBSONIC_MUSIC_FOLDER} --default-podcast-folder=${SUBSONIC_PODCAST_FOLDER} --default-playlist-folder=${SUBSONIC_PLAYLIST_FOLDER}

tail -F ${SUBSONIC_HOME}/subsonic_sh.log
