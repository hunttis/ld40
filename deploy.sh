#!/usr/bin/env bash
#
# Deploy Astrofarmer to Google Cloud.
#
# To run this script successfully, you need to be
# logged in to Google Cloud as a user who has
# the required permissions to bucket gs://astrofarmer.net.
#
# The way to obtain those permissions is to ask
# Ville Peurala, also known as Kukko at Wunderdog.
# Contact him in Slack or send mail to <ville.peurala@wunderdog.fi>.
#
# Your current working directory must be inside the ld40
# git repository when you run this script.
#
# If all goes well, the game will be playable at [http://astrofarmer.net]
# after running this script.

echo "Starting to build and deploy Astrofarmer to Google Cloud..."
pushd . >/dev/null
cd $(git rev-parse --show-toplevel)
lime clean html5
haxe --wait 6000 >/dev/null 2>&1 &
BACKGROUND_COMPILER_PID=$!
lime build html5
kill $BACKGROUND_COMPILER_PID >/dev/null 2>&1
wait $BACKGROUND_COMPILER_PID >/dev/null 2>&1
gsutil defacl ch -u AllUsers:READ gs://astrofarmer.net
gsutil -m rsync -d -r export/html5/bin gs://astrofarmer.net
gsutil acl ch -u AllUsers:READ gs://astrofarmer.net
popd >/dev/null

