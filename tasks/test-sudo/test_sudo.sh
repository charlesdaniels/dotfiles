#!/bin/sh

echo "testing sudo... "
echo "pw is: $TASKUTIL_SUDO_PASSWORD"
echo "$TASKUTIL_SUDO_PASSWORD" | sudo -S whoami
