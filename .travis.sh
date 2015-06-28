#!/bin/bash

# Travis CI support script


# Arguments parsing
if [ $# -ne 1 ]; then
	echo "Usage: ${0} <STEP>"
	exit 1
fi


# Routines ---------------------------------------------------------------------

# before_install
before_install() {
	sudo apt-get -qq update
}

# install
install() {
	sudo apt-get -qq install zip
}

# script
script() {
	_VERSION="$(git show :VERSION)"
	__VERSION="$(git show HEAD^:VERSION)"
	if [ "${_VERSION}" == "${__VERSION}" ]; then
		VERSION="${_VERSION}"
	else
		VERSION="${__VERSION}"
	fi
	git diff --name-only "v${VERSION}" | fgrep -v -e ".gitattributes" \
		                                      -e ".travis.sh" \
		                                      -e ".travis.yml" \
		                                      -e "README.md" | zip -9 "unrealarena-data.pre.zip" -@
}


# Main -------------------------------------------------------------------------

# Arguments check
if ! `declare -f "${1}" > /dev/null`; then
	echo "Error: unknown step \"${1}\""
	exit 1
fi

# Enable exit on error & display of executing commands
set -ex

# Call <STEP>
${1}
