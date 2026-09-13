#!/bin/bash
# Created By ImCubical
# PUT THIS IN YOUR MACINTOSH HD VOLUME.

SYS_VOL="/Volumes/Macintosh HD"
REPO_PATH="$SYS_VOL/Users/Shared/m1n1"
OS_VERSION=$(sw_vers -productVersion)
MAJOR_VERSION=$(echo "$OS_VERSION" | cut -d. -f1)

export GIT_SSL_CAINFO="$SYS_VOL/etc/ssl/cert.pem"

echo "Updating m1n1 repository..."

if [ ! -d "$REPO_PATH/.git" ]; then
    echo "Repository not found locally. Cloning..."
    "$SYS_VOL/usr/bin/git" clone https://github.com/ImAtomiskk/asahim5.git "$REPO_PATH"
else
    echo "Repository exists. Pulling latest..."
    "$SYS_VOL/usr/bin/git" --git-dir="$REPO_PATH/.git" --work-tree="$REPO_PATH" pull
fi

if [ $? -eq 0 ]; then
    echo "Git sync complete!"
else
    echo "Git update failed."
    exit 1
fi

if [ ! -d "$REPO_PATH/.git" ]; then
    echo "Preparing to Install m1n1.."
else
    echo "Preparing to Update m1n1.."
fi


if [ "$MAJOR_VERSION" -ge 11 ]; then
    echo "Starting Installation for macOS" "$MAJOR_VERSION""..."
    kmutil configure-boot -c "/Volumes/Macintosh HD/Users/Shared/asahim5/m1n1/build/m1n1.bin" \
        --raw-boot-object "$REPO_PATH/build/m1n1.bin"
else
    echo "Applying steps for older macOS versions (10.15 and below)..."
    kmutil configure-boot -c "/Volumes/Macintosh HD/Users/Shared/asahim5/m1n1/build/m1n1.bin" \
        --raw-boot-object "$REPO_PATH/m1n1/build/m1n1.macho"
fi

if [ $? -eq 0 ]; then
    echo "Firmware successfully updated with new m1n1 object!"
else
    echo "Error: kmutil failed to flash the boot object."
    exit 1
fi

