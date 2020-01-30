# DKIM Certificates generation - dedicated for autonamic high volume keys generation
# Developed in 2020 by C.PEKAR / AKAOMA
#!/bin/bash

domainkey="mailing"
domains=(
        'domain1.com'
        'domain2.org'
        'domain3.zyx'
)

result="publickeys_spfs.txt"
directory="/etc/opendkim"
keysdirectory="keys"

keytable="key.table"
signingtable="signing.table"
trustedhosts="trusted.hosts"

for domain in "${domains[@]}"
do
keydir="$directory/$keysdirectory/$domain"
if [ -d "$keydir" ]
then
cd $keydir
echo "WARNING! Domain $domain already exist!  To proceed with it just delete the previous directory then relaunch the script."
else
mkdir $keydir
cd $keydir
opendkim-genkey -r -d $domain -s $domainkey
chown opendkim:opendkim $domainkey.private
echo "$domainkey._domainkey.$domain $domain:$domainkey:$keydir/$domainkey.private" >> $directory/$keytable
echo "$domain $domainkey._domainkey.$domain" >> $directory/$signingtable
echo "$domain" >> $directory/$trustedhosts
echo "$(cat $keydir/$domainkey.txt)" >> $directory/$result
echo "$domain DKIM Certificates are processed with correct filesystem restrictions. Location: $keydir"
fi
done
