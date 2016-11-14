# oasctl
This is an old script used to manage OAS10g 10.1.2, 10.1.3 and 10.1.4. 
I have decided to donate to the open source community. It is unlikely that this script is still in use at any locations, but perhaps some users are still using it?

## Basics
This script covers the oas, infra, grid and oai
You must have an enviroment script called
<target>.env for each tartget you want to
administrate, e.g.  oas.env and infra.env

## Configuration
Edit oasctl.sh and make sure the SDIR enviroment is set to the folder where you
keep the oasctl.sh script and all the \*.env files

## Syntax
Usage:   ./oasctl.sh oas|infra|omr|oms|oma|ocsapps|ocsinfra|db start|stop|status

## Example
oasctl infra start
oasctl oas start
oasctl infra status
oasctl oas status
oasctl oas stop
oasctl infra stop

## Boot script
* Place oas-initd.sh in /etc/init.d
* Create symbolic links from runlevel 3 and 5 to get OAS started at server boot and stopped at shutdown:
```bash
cd /etc/rc3.d
ln -s /etc/init.d/oas-initd.sh S99oasctl
ln -s /etc/init.d/oas-initd.sh K00oasctl
cd /etc/rc5.d
ln -s /etc/init.d/oas-initd.sh S99oasctl
ln -s /etc/init.d/oas-initd.sh K00oasctl
```
