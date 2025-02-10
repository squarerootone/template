#!/bin/bash

echo "Instance started"

# set up gcp creds
GOOGLE_APPLICATION_CREDENTIALS=$(eval echo $GOOGLE_APPLICATION_CREDENTIALS)
if [ ! -f $GOOGLE_APPLICATION_CREDENTIALS ]; then
    echo "Creating GCP SA key"
    mkdir -pv $(dirname $GOOGLE_APPLICATION_CREDENTIALS)
    touch $GOOGLE_APPLICATION_CREDENTIALS
    echo $GCP_KEY >> $GOOGLE_APPLICATION_CREDENTIALS
    echo "Done creating GCP SA key"
fi

# set up gh ssh creds << step ssh-add not working, and don't need gh ssh anyways
# if [ ! -f $HOME/.ssh/id_ed25519 ]; then
#     echo "Creating SSH key for GH!"
#     mkdir -pv $HOME/.ssh
#     echo $GH_SSH_KEY >> $HOME/.ssh/id_ed25519
#     sed -i -e 's/BEGIN OPENSSH PRIVATE KEY----- /BEGIN OPENSSH PRIVATE KEY-----\n/' $HOME/.ssh/id_ed25519
#     sed -i -e 's/ -----END OPENSSH PRIVATE KEY/\n-----END OPENSSH PRIVATE KEY/' $HOME/.ssh/id_ed25519
#     sed -i -e 'n;2 s/ /\n/g' $HOME/.ssh/id_ed25519
#     chmod 600 $HOME/.ssh/id_ed25519
#     echo "Done creating SSH key for GH"
# fi
# echo "Initiating SSH key for GH"
# eval "$(ssh-agent -s)"
# ssh-add $HOME/.ssh/id_ed25519
# echo "Done initiating SSH key for GH"

# remove the jetbrains idea editor
rm -rf /workspaces/.codespaces/shared/editors/jetbrains/;

# Login to gcloud
gcloud auth login --cred-file=$GOOGLE_APPLICATION_CREDENTIALS
