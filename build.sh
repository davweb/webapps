#!/bin/bash

OUTPUT=/var/tmp

function create_app {
    NAME=$1
    ICON=$2
    URL=$3
    shift 3
    EXTRAS=$*

    nativefier --name "${NAME}" --icon "${ICON}" --fast-quit --single-instance ${EXTRAS} "${URL}" "${OUTPUT}"
    
    pkill "${NAME}"

    pushd ${OUTPUT}
    pushd "${NAME}-darwin-x64"
    rm -r "/Applications/${NAME}.app"
    mv "${NAME}.app" /Applications
    popd
    rm -rf "${NAME}-darwin-x64"
    popd
}

brew upgrade nativefier
create_app "Board Game Arena" bga.png https://boardgamearena.com/
create_app "UniFi Network" ubiquiti.png https://furia.home:8443/ --ignore-certificate
create_app "BBC Sounds" bbc-sounds.png https://www.bbc.co.uk/sounds --internal-urls 'bbc.com' --internal-urls 'bbc.co.uk'
create_app "Overcast" overcast.png https://overcast.fm/podcasts
