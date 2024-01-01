set -eux

if [ $# -ne 1 ]
then
	echo Usage: $0 USER@SERVER:DIR/
	exit 1
fi

# If we don't clean then the TOC might be out of date. For some reason.
pipenv run make clean
pipenv run make html
rsync -r -P --exclude-from rsync-excludes.txt build/html/ "$1"

