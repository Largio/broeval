##! Local site policy. Customize as appropriate. 
##!
##! This file will not be overwritten when upgrading or reinstalling


@load-sigs frameworks/signatures/sigs-testbed
# This script logs which scripts were loaded during each run.
@load misc/loaded-scripts

# Apply the default tuning scripts for common tuning settings.
@load tuning/defaults

# Load the scan detection script.
@load misc/scan

# Log some information about web applications being used by users 
# on your network.
@load misc/app-stats

# Detect traceroute being run on the network.  
@load misc/detect-traceroute

# Generate notices when vulnerable versions of software are discovered.
# The default is to only monitor software found in the address space defined
# as "local".  Refer to the software framework's documentation for more 
# information.
@load frameworks/software/vulnerable

# Detect software changing (e.g. attacker installing hacked SSHD).
@load frameworks/software/version-changes

# This adds signatures to detect cleartext forward and reverse windows shells.
@load-sigs frameworks/signatures/detect-windows-shells

# Load all of the scripts that detect software in various protocols.
@load protocols/ftp/software
@load protocols/smtp/software
@load protocols/ssh/software
@load protocols/http/software
# The detect-webapps script could possibly cause performance trouble when 
# running on live traffic.  Enable it cautiously.
@load protocols/http/detect-webapps

# This script detects DNS results pointing toward your Site::local_nets 
# where the name is not part of your local DNS zone and is being hosted 
# externally.  Requires that the Site::local_zones variable is defined.
@load protocols/dns/detect-external-names

# Script to detect various activity in FTP sessions.
@load protocols/ftp/detect

# Scripts that do asset tracking.
@load protocols/conn/known-hosts
@load protocols/conn/known-services
@load protocols/ssl/known-certs

# This script enables SSL/TLS certificate validation.
@load protocols/ssl/validate-certs

# This script prevents the logging of SSL CA certificates in x509.log
@load protocols/ssl/log-hostcerts-only

# Uncomment the following line to check each SSL certificate hash against the ICSI
# certificate notary service; see http://notary.icsi.berkeley.edu .
 @load protocols/ssl/notary

# If you have libGeoIP support built in, do some geographic detections and 
# logging for SSH traffic.
@load protocols/ssh/geo-data
# Detect hosts doing SSH bruteforce attacks.
@load protocols/ssh/detect-bruteforcing
# Detect logins using "interesting" hostnames.
@load protocols/ssh/interesting-hostnames

# Detect SQL injection attacks.
@load protocols/http/detect-sqli

#### Network File Handling ####

# Enable MD5 and SHA1 hashing for all files.
@load frameworks/files/hash-all-files

# Detect SHA1 sums in Team Cymru's Malware Hash Registry.
@load frameworks/files/detect-MHR

# Uncomment the following line to enable detection of the heartbleed attack. Enabling
# this might impact performance a bit.
 @load policy/protocols/ssl/heartbleed


###### TESTBED HEIDELBERG MAX ####################

@load frameworks/dpd/packet-segment-logging
@load frameworks/dpd/detect-protocols
@load frameworks/files/extract-all-files
@load frameworks/intel/seen
@load frameworks/intel/do_notice
@load frameworks/packet-filter/shunt
@load frameworks/software/windows-version-detection
@load misc/capture-loss
@load misc/known-devices
@load misc/profiling
@load misc/load-balancing
@load misc/stats
@load misc/trim-trace-file
@load protocols/conn/weirds
@load protocols/dhcp/known-devices-and-hostnames
@load protocols/dns/auth-addl
@load protocols/ftp/detect-bruteforcing
@load protocols/http/var-extraction-uri
@load protocols/http/var-extraction-cookies
@load protocols/http/header-names
@load protocols/http/software-browser-plugins
@load protocols/modbus/track-memmap
@load protocols/modbus/known-masters-slaves
@load protocols/mysql/software
@load protocols/rdp/indicate_ssl
@load protocols/smtp/blocklists
@load protocols/smtp/detect-suspicious-orig
@load protocols/smtp/entities-excerpt
@load protocols/ssl/validate-ocsp
@load protocols/ssl/expiring-certs
@load protocols/ssl/weak-keys
@load protocols/ssl/extract-certs-pem
@load tuning

#Both start a second process
#@load frameworks/communication/listen
#@load frameworks/control/controllee

###Terminates asap
#@load frameworks/control/controller
#######

#Alot of output!
#@load misc/dump-events
#######

