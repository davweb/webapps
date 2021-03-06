#!/bin/bash -e

# Set temporary working directory
OUTPUT=/var/tmp

# function to run nativefier and copy .app file
function create_app {
    NAME=$1
    ICON=$2
    URL=$3
    shift 3
    EXTRAS=$*

    echo Building ${NAME}...

    nativefier --electron-version ${ELECTRON_VERSION} ${EXTRAS} --name "${NAME}" --icon "${ICON}" --fast-quit  "${URL}" "${OUTPUT}" >/dev/null  2>&1

    pkill "${NAME}" || true

    pushd ${OUTPUT}
    pushd "${NAME}-darwin-x64"
    rm -rf "/Applications/${NAME}.app"
    mv "${NAME}.app" /Applications
    popd
    rm -rf "${NAME}-darwin-x64"
    popd
}

# Make pushd and popd silent
pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

# Make sure we're in the directory with the source files
cd `dirname ${BASH_SOURCE}`

# Clear out working files in case previous run was interupted
rm -rf ${OUTPUT}/darwin-x64-template

# Update Nativefier
brew upgrade nativefier

# Use most recent version of electron
ELECTRON_VERSION=`curl --silent "https://api.github.com/repos/electron/electron/releases" | jq --raw-output 'map(.tag_name) | map(select(contains("alpha") or contains ("beta") | not)) | sort | .[-1][1:]'`
echo Using Electron version ${ELECTRON_VERSION}

create_app "Board Game Arena" bga.png https://boardgamearena.com/
create_app "UniFi Network" ubiquiti.png https://furia.home:8443/ --ignore-certificate
create_app "BBC Sounds" bbc-sounds.png https://www.bbc.co.uk/sounds --internal-urls 'bbc.com' --internal-urls 'bbc.co.uk'
create_app "Overcast" overcast.png https://overcast.fm/podcasts --inject './overcast.js'
create_app "Dark Sky" dark-sky.png https://darksky.net/forecast/51.7453,-1.2916/uk212/en
create_app "Plex" plex.png http://plex.home/web/index.html  --internal-urls 'plex.tv'
