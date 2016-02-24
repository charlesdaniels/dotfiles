#!/bin/sh

NAME=$1
REPOSITORY=/tank/borg
if [ ! -d "${REPOSITORY}" ]; then
  echo "Backup folder is not running, not continuing with backup"
  exit
fi
echo "Backup folder exists... proceeding with backup"

# Backup all of /home and /var/www except a few
# excluded directories
borg create -v --stats                          \
    $REPOSITORY::`hostname`-`date +%Y-%m-%d`-manual-$NAME    \
    /home                                       \

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. --prefix `hostname`- is very important to
# limit prune's operation to this machine's archives and not apply to
# other machine's archives also.
borg prune -v $REPOSITORY --prefix `hostname`- \
    --keep-daily=7 --keep-weekly=4 --keep-monthly=6
