#!/bin/bash
# SPDX-License-Identifier: MIT

set -e

if [ "${0%/*}" != "$0" ]; then
    cd "${0%/*}"
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export REPO_BASE=https://cdn.asahilinux.org
export DYLD_LIBRARY_PATH=$PWD/Frameworks/Python.framework/Versions/Current/lib
export DYLD_FRAMEWORK_PATH=$PWD/Frameworks
python=Frameworks/Python.framework/Versions/3.13/bin/python3.13
export SSL_CERT_FILE=$PWD/Frameworks/Python.framework/Versions/Current/etc/openssl/cert.pem
# Bootstrap does part of this, but install.sh can be run standalone
# so do it again for good measure.
export PATH="$PWD/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"


# Configuration - Change these to match your setup
instdata="asahi-installer/installer_data.json"
main="asahi-installer/main.py"
REMOTE_BRANCH="origin/main"

echo "Fetching latest updates from remote..."
git fetch

# Check if the file exists on the remote branch
if ! git rev-parse "$REMOTE_BRANCH:$instdata" >/dev/null 2>&1; then
    echo "Error: File '$instdata' does not exist on '$REMOTE_BRANCH'."
    exit 1
fi
if ! git rev-parse "$REMOTE_BRANCH:$main" >/dev/null 2>&1; then
    echo "Error: File '$main' does not exist on '$REMOTE_BRANCH'."
    exit 1
fi

echo "Checking for updates to: $instdata"
echo "Checking for updates to: $main"

# Compare local file against the remote version
git diff --exit-code "$REMOTE_BRANCH" -- "$instdata" > /dev/null
git diff --exit-code "$REMOTE_BRANCH" -- "$main" > /dev/null

# Exit code 0 means they are identical; code 1 means they are different
if [ $? -eq 0 ]; then
    echo "The files are already up to date."
else
    echo "A new version was found! Updating $instdata..."
    
    # Pull only that specific file from the remote branch
    git checkout "$REMOTE_BRANCH" -- "$instdata"
    git checkout "$REMOTE_BRANCH" -- "$main"

    
    if [ $? -eq 0 ]; then
        echo "Files updated successfully!"
    else
        echo "Failed to update files."
        exit 1
    fi
fi

set +e
macos_ver=$(/usr/libexec sudo/PlistBuddy -c "Print :ProductVersion" \
	/System/Library/CoreServices/SystemVersion.plist)
res=$?
set -e

if [ "$res" -ne 0 ] || [ -z "$macos_ver" ]; then
    echo "Unable to determine macOS version. Please report a bug."
    exit 1
fi

if [ "${macos_ver%%.*}" -lt 12 ]; then
    echo "This installer requires macOS 12.3 or later."
    exit 1
fi

if ! arch -arm64 ls >/dev/null 2>/dev/null; then
    echo
    echo "Looks like this is an Intel Mac!"
    echo "Sorry, Asahi Linux only supports Apple Silicon machines."
    echo "May we interest you in https://t2linux.org/ instead?"
    exit 1
fi

if [ $(arch) != "arm64" ]; then
    echo
    echo "You're running the installer in Intel mode under Rosetta!"
    echo "Don't worry, we can fix that for you. Switching to ARM64 mode..."

    # This loses env vars in some security states, so just re-launch ourselves
    exec sudo arch -arm64 ./install.sh
fi

exec </dev/tty >/dev/tty 2>/dev/tty
exec sudo $python main.py "$@"
