#!/usr/bin/env bash

# Do we have necessary python modules installed?
if python -c "import build, installer, wheel, setuptools"; then
  echo "Packages python-build, python-installer, python-wheel, python-setuptools found."
else
  echo "One of 'python-build', 'python-installer', 'python-wheel', 'python-setuptools' not found, terminating."
  exit 1
fi

PROGRAM_NAME="nwg-clipman"
MODULE_NAME="nwg_clipman"
SITE_PACKAGES="$(python3 -c "import sysconfig; print(sysconfig.get_paths()['purelib'])")"
PATTERN="$SITE_PACKAGES/$MODULE_NAME*"

# Remove from site_packages
for path in $PATTERN; do
    if [ -e "$path" ]; then
        echo "Removing $path"
        rm -r "$path"
    fi
done

# Remove launcher script
if [ -f "/usr/bin/$PROGRAM_NAME" ]; then
  echo "Removing /usr/bin/$PROGRAM_NAME"
  rm "/usr/bin/nwg-clipman"
fi

python -m build --wheel --no-isolation
python -m installer dist/*.whl

install -Dm 644 -t "/usr/share/pixmaps" "$PROGRAM_NAME.svg"
install -Dm 644 -t "/usr/share/applications" "$PROGRAM_NAME.desktop"
install -Dm 644 -t "/usr/share/licenses/$PROGRAM_NAME" LICENSE
install -Dm 644 -t "/usr/share/doc/$PROGRAM_NAME" README.md
