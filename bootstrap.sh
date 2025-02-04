#!/usr/bin/env bash
# Running as `source bootstrap.sh` from zsh fails. You need to run it as bash
# so simply `./bootstrap.sh` or `bash bootstrap.sh` works.

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function doIt() {
	FILES=`find . -name '*' \
		-and ! -name '.' \
		-and ! -name 'README.md' \
		-and ! -name 'bootstrap.sh' \
		-and ! -path './.git/*'  \
		-and ! -name '.git' \
		-and ! -name '.DS_Store' \
		-and ! -name 'LICENSE-MIT.txt'`
	while read -r file; do
		dir=$(dirname "${file}")
		# dir either starts with a './' or is '.'
		# make it so it always starts with a '/', or is ''
		dir=${dir:1}
		dest="${HOME}${dir}"
		cp -vfa "${file}" "${dest}"
	done <<< "${FILES}"
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
