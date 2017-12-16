#!/usr/bin/env bash
#
# Deploy Astrofarmer to Firebase hosting.
#
# To run this script successfully, you need to be
# logged in to Firebase as a user who has
# the required permissions to Firebase project
# with id "astrofarmer-1977".
#
# The way to obtain those permissions is to ask
# Ville Peurala, also known as Kukko at Wunderdog.
# Contact him in Slack or send mail to <ville.peurala@wunderdog.fi>.
#
# Your current working directory must be inside the ld40
# git repository when you run this script.
#
# If all goes well, the game will be playable at the following places
# after running this script:
# - [https://astrofarmer.net]
# - [https://www.astrofarmer.net]
# - [http://astrofarmer.net]
# - [http://www.astrofarmer.net]

echo "Starting to build and deploy Astrofarmer to Firebase..."
DEPLOYER_NAME=$(finger -l | grep "Name:" | sed 's/^.*Name: //g')
DEPLOYMENT_TIME=$(date -j "+%A %d.%m.%Y% at %H:%M:%S")
pushd . >/dev/null
cd $(git rev-parse --show-toplevel)
lime clean html5
haxe --wait 6000 >/dev/null 2>&1 &
BACKGROUND_COMPILER_PID=$!
lime build html5
kill $BACKGROUND_COMPILER_PID >/dev/null 2>&1
wait $BACKGROUND_COMPILER_PID >/dev/null 2>&1
cp extra-deployment-resources/* export/html5/bin/
firebase deploy -m "Deployment by ${DEPLOYER_NAME} on ${DEPLOYMENT_TIME}"
popd >/dev/null

