#!/usr/bin/env bash

help() {
  cat <<EOF
  Arguments:
  +\$1 given username

  Usage example:
  $ ./add-docker-user.sh jenkins
EOF
}

# init vars
USR=$1
if [[ -z $USR ]]; then
  help
  exit 1
fi

# generate SSH key pairs
ssh-keygen -q -N '' -m PEM -t rsa -f "~/.ssh/id_rsa_$USR" <<< y

# create new user
useradd -m -d /home/$USR -s /bin/bash $USR
usermod -aG docker $USR
mkdir /home/$USR/.ssh
touch /home/$USR/.ssh/authorized_keys
cat "$HOME/.ssh/id_rsa_$USR.pub" > /home/$USR/.ssh/authorized_keys
ssh -i $HOME/.ssh/id_rsa_$USR $USR@localhost "docker --version && echo '>>> DONE. New user added'"
