#!/bin/bash

# Set values for variables
set -e

DOMAIN=$1
DOMAIN_USER=$2
DOMAIN_USER_PASS=$3
SUDO_GROUPS=$4

# install prerequisite packages to domain join
yum install sssd realmd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools krb5-workstation openldap-clients policycoreutils-python -y

# Join the domain
echo $DOMAIN_USER_PASS | realm join $DOMAIN -U $DOMAIN_USER

# Allow interaction with AD objects without the domain suffixes
sed -i '/use_fully_qualified_names = True/c\use_fully_qualified_names = False' /etc/sssd/sssd.conf 
systemctl restart sssd

export OLDIFS= $IFS
export IFS=";"
for group in $SUDO_GROUPS; do
  echo "%$group ALL=(ALL)  ALL" >> /etc/sudoers
done
export IFS="$OLDIFS"

