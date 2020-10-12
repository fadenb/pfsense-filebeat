#!/usr/bin/env sh

# Stop filebeat if it's already running...
if [ -f /usr/local/etc/rc.d/filebeat ]; then
  echo "Stopping filebeat service..."
  /usr/sbin/service filebeat stop
  echo "done."
fi

#Remove current version and config
echo "Removing beats[6|7]..."
/usr/sbin/pkg remove -y beats || true
/usr/sbin/pkg remove -y beats6 || true
/usr/sbin/pkg remove -y beats7 || true
/bin/rm /usr/local/etc/rc.d/filebeat.sh
/bin/rm /usr/local/etc/filebeat.yml
echo "done."

#Download filebeat binary
echo "Downloading filebeat binary..."
curl --location --output /usr/local/sbin/filebeat https://github.com/omniitgmbh/beats/releases/download/v7.9.2/filebeat
echo "done."

# Make filebeat auto start at boot
echo "Installing rc script..."
/bin/cp /usr/local/etc/rc.d/filebeat /usr/local/etc/rc.d/filebeat.sh
echo " done."

# Add the startup variable to rc.conf.local.
# In the following comparison, we expect the 'or' operator to short-circuit, to make sure the file exists and avoid grep throwing an error.
if [ ! -f /etc/rc.conf.local ] || [ "$(grep -c filebeat_enable /etc/rc.conf.local)" -eq 0 ]; then
  echo "Enabling filebeat service..."
  echo "filebeat_enable=YES" >> /etc/rc.conf.local
  echo "done."
fi

# Copy config from Github
/usr/local/bin/curl https://raw.githubusercontent.com/fadenb/pfsense-filebeat/master/filebeat.yml --output /usr/local/etc/filebeat.yml

# Start it up:
echo "Starting filebeat service..."
/usr/sbin/service filebeat start
echo "done."
