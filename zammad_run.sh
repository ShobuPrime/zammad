#!/bin/sh

# Attempting to use docker environment variables
usermod -u ${USER_ID} ${ZAMMAD_USER} -g ${GROUP_ID} -G ${ZAMMAD_USER},adm,cdrom,sudo,dip,plugdev;

# How to: https://linuxize.com/post/bash-check-if-file-exists/
# If the "zammad_data" shared volume is empty
if [ "$(ls -A /shared/zammad_data)" ]; then
	# If the "elasticsearch", "postgresql", and "zammad" folders already exist in persistent data volume
	if [ -d "/shared/zammad_data/elasticsearch" -a -d "/shared/zammad_data/postgresql" -a -d "/shared/zammad_data/zammad" ]; then
		# Delete static data from docker image
		echo "Cleaning environment: remove folders or links.";
		rm -rf /var/lib/elasticsearch;
		rm -rf /var/lib/postgresql;
		rm -rf /opt/zammad;
	else
		# If the folders don't exist, notify user they may not have a good time
		echo "ERROR: Partial data folder.";
		echo "NOTE: For a new instance the folder /shared/zammad_data must be empty.";
		#exit 1;
	fi
else
	# If the "zammad_data" directory is not empty, make sure to copy fresh data from the container
	echo "Changing permissions of data from container in an attempt to make persistent data on host accessible"
	chgrp -R ${GROUP_ID} /var/lib/elasticsearch;
	chmod -R 775 /var/lib/elasticsearch;
	chgrp -R ${GROUP_ID} /var/lib/postgresql;
	chmod -R 750 /var/lib/postgresql;
	chgrp -R ${GROUP_ID} /opt/zammad;
	chmod -R 775 /opt/zammad;
	echo "Moving managed data folders to the mounted folder.";
	mv /var/lib/elasticsearch /shared/zammad_data;
	mv /var/lib/postgresql /shared/zammad_data;
	mv /opt/zammad /shared/zammad_data;
fi

echo "Creating config backup file if necessary";
[ -f /opt/zammad/contrib/backup/config ] || cp /opt/zammad/contrib/backup/config.dist /opt/zammad/contrib/backup/config

# Ensure persistent data links to original locations
echo "Creating new links.";
ln -s /shared/zammad_data/elasticsearch /var/lib/elasticsearch;
ln -s /shared/zammad_data/postgresql /var/lib/postgresql;
ln -s /shared/zammad_data/zammad /opt/zammad;

echo "Fixing Postgres corrupted sessions if necessary.";
su - postgres -c "/usr/lib/postgresql/11/bin/pg_resetxlog -f /var/lib/postgresql/11/main/";
/docker-entrypoint.sh zammad;
