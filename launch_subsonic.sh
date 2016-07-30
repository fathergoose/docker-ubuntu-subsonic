#! /bin/sh

# Set defaults.
SUBSONIC_PORT=4040
SUBSONIC_HTTPS_PORT=0


# Parse arguments.
while [ $# -ge 1 ]; do
    case $1 in
        --https)
            SUBSONIC_PORT=0
            SUBSONIC_HTTPS_PORT=4050
            ;;
    esac
    shift
done

# Launch.
${SUBSONIC_HOME}/subsonic.sh --port=${SUBSONIC_PORT} --https-port=${SUBSONIC_HTTPS_PORT} --default-music-folder=${SUBSONIC_MUSIC_FOLDER} --default-podcast-folder=${SUBSONIC_PODCAST_FOLDER} --default-playlist-folder=${SUBSONIC_PLAYLIST_FOLDER}

# Keep running.
tail -F ${SUBSONIC_HOME}/subsonic_sh.log
