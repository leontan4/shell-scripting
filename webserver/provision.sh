#!/bin/bash
# updating the required packages
ACTION=${1}
SUPER_USER='sudo'
UPDATE_PACKAGE='yum update -y'
UPDATE_GIT='yum install git -y'

NGINX_INSTALL='amazon-linux-extras install nginx1.12 -y'
NGINX_START='service nginx'
NGINX_REBOOT='chkconfig nginx on'
NGINX_UNINSTALL='yum remove nginx -y'

FILE_DIRECTORY='/usr/share/nginx/html/'
FILE_NAME='index.html'
AWS_SERVER='aws s3 cp s3://'
S3_SERVER='tan04653-assignment-webserver/'

VERSION='1.0.0'

function system_update() {

$SUPER_USER $UPDATE_PACKAGE
$SUPER_USER $UPDATE_GIT
$SUPER_USER $NGINX_INSTALL
$SUPER_USER $NGINX_REBOOT
$FILE_DIRECTORY
$SUPER_USER $AWS_SERVER$S3_SERVER$FILE_NAME $FILE_DIRECTORY$FILE_NAME
$SUPER_USER $NGINX_START start

}

function remove_file() {

$SUPER_USER $NGINX_REBOOT
rm $FILE_DIRECTORY$FILE_NAME
$SUPER_USER $NGINX_UNINSTALL stop
}

function system_version() {

echo "VERSION: ${VERSION}"
}

function system_help() {
cat<<EOF
USAGE: ${0} {-u|--update|-r|--remove|-v|--version|-h|--help} 

OPTIONS:
	-u | --update	Update system package and download html file
	-r | --remove	Remove files, turn off and delete nginx
	-v | --version	Display current system version
	-h | --help 	Display the command help

Examples:
	System updates and installs:
		$ ${0} -u

	Delete and uninstall packages:
		$ ${0} -r

	Display current version:
		$ ${0} -v

	Display help command:
		$ ${0} -h
EOF
}


case "$ACTION" in 
	-r|--remove)
		remove_file
		;;
	-v|--version)
		system_version
		;;
	-h|--help)
		system_help
		;;
	-u|--update)
		system_update
		;;
	*)
	exit 1
esac
