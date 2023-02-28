#!/bin/bash
set -euo pipefail
echo "Backing up Docker..."
systemctl stop docker.service
BACKUP_FILE=docker-before-dockremap-$(date +%s).tar.bz2
tar cjf /var/lib/$BACKUP_FILE /var/lib/docker
echo "Enabling userns-remap..."
[ -f /etc/docker/daemon.json ] || echo "{}" > /etc/docker/daemon.json
jq '."userns-remap"="default"' /etc/docker/daemon.json > /tmp/daemon.json
mv /tmp/daemon.json /etc/docker/daemon.json
systemctl start docker.service
echo "Checking whether user and group have been created..."
grep dockremap /etc/passwd
grep dockremap /etc/group
REMAP_UID=$(grep dockremap /etc/subuid | cut -d: -f2)
REMAP_GID=$(grep dockremap /etc/subgid | cut -d: -f2)
echo "Checking whether containers actually get remapped..."
pushd $(mktemp -d)
chmod o+r .
chmod o+w .
chmod o+x .
docker run -ti --rm -v $(pwd):/host busybox touch /host/test.txt
stat test.txt --format=%u:%g | grep $REMAP_UID:$REMAP_GID
echo "migrating docker stuff..."
cp /var/lib/$BACKUP_FILE ./
chmod o+r $BACKUP_FILE
docker run -ti --rm -v $(pwd):/host busybox sh -c "cd /host && tar xjf $BACKUP_FILE"
rm $BACKUP_FILE
systemctl stop docker.service
rm -rf /var/lib/docker
mv var/lib/docker /var/lib
systemctl start docker.service
#echo "redeploying all stacks..."
#./deploy-stacks.sh

