#!/bin/sh
# SPDX-License-Identifier: MIT

# Truncation guard
if true; then
    set -e
    echo Welcome to the Asahi Downloader
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ -e /sys ]; then
            echo "Download Platform: Linux ($PRETTY_NAME)"
            echo "Proceeding.. Please Wait"
        elif [ -e /System ]; then
            echo "Download Platform: macOS"
            echo "Proceeding.. Please Wait"
        else
            echo "You appear to be running this script from Windows."
            echo "Asahi Linux can only be installed from macOS, or downloaded on Linux"
            exit 0
        fi
    elif command -v sw_vers &> /dev/null; then
        if [ -e /sys ]; then
            echo "Download Platform: Linux"
            echo "Proceeding.. Please Wait"
        elif [ -e /System ]; then
            echo "Download Platform: macOS (macOS $(sw_vers -productVersion))"
            echo "Proceeding.. Please Wait"
        else
            echo "You appear to be running this script from Windows."
            echo "Asahi Linux can only be installed from macOS, or downloaded on Linux"
            exit 0
        fi
    else
        echo "Device Version not found, builds may be inaccurate"
        if [ -e /sys ]; then
            echo "Download Platform: Linux"
            echo "Proceeding.. Please Wait"
        elif [ -e /System ]; then
            echo "Download Platform: macOS (macOS $(sw_vers -productVersion))"
            echo "Proceeding.. Please Wait"
        else
            echo "You appear to be running this script from Windows."
            echo "Asahi Linux can only be installed from macOS, or downloaded on Linux"
            exit 0
        fi
    fi

    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

    if ! curl --no-progress-meter file:/// >/dev/null 2>&1; then
        echo "Your version of cURL is too old. This usually means your macOS is very out"
        echo "of date. Installing Asahi Linux requires at least macOS version 13.5."
        exit 1
    fi

    export VERSION_FLAG=https://cdn.asahilinux.org/installer/latest
    export INSTALLER_BASE=https://cdn.asahilinux.org/installer
    export INSTALLER_DATA=https://github.com/AsahiLinux/asahi-installer-data/raw/prod/data/installer_data.json
    export INSTALLER_DATA_ALT=https://alx.sh/installer_data.json
    export REPO_BASE=https://cdn.asahilinux.org
    export REPORT=https://stats.asahilinux.org/report
    export REPORT_TAG=alx-prod

    #Install="$(mktemp -d)"
    Install=$(pwd)/asahi-installer

    echo
    echo "Bootstrapping installer:"

    mkdir -p "$Install"
    cd "$Install"

    echo "  Checking version..."

    PKG_VER="$(curl --no-progress-meter -L "$VERSION_FLAG")"
    echo "  Version: $PKG_VER"

    PKG="installer-$PKG_VER.tar.gz"

    echo "  Downloading..."

    curl --no-progress-meter -L -o "$PKG" "$INSTALLER_BASE/$PKG"
    if ! curl --no-progress-meter -L -O "$INSTALLER_DATA"; then
        echo "    Error downloading installer_data.json. GitHub might be blocked in your network."
        echo "    Please consider using a VPN if you experience issues."
        echo "    Trying workaround..."
        curl --no-progress-meter -L -O "$INSTALLER_DATA_ALT"
    fi

    echo "  Extracting..."

    tar xf "$PKG"
    echo "  Installer Downloaded!"
    while true; do
        read -r -p "Do you want to add M5 patches? (y/n): " response
        case "$response" in
            [Yy]* )
                echo "Updating Installer.."

                set -e

                tmpdir=$(mktemp -d)
                trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM

                curl -fL --retry 3 \
                    "https://raw.githubusercontent.com/ImAtomiskk/asahim5/main/asahi-installer/main.py" \
                    -o "$tmpdir/main.py"

                curl -fL --retry 3 \
                    "https://raw.githubusercontent.com/ImAtomiskk/asahim5/main/asahi-installer/stub.py" \
                    -o "$tmpdir/stub.py"

                curl -fL --retry 3 \
                    "https://raw.githubusercontent.com/ImAtomiskk/asahim5/main/asahi-installer/osinstall.py" \
                    -o "$tmpdir/osinstall.py"

                python3 -m py_compile \
                    "$tmpdir/main.py" \
                    "$tmpdir/stub.py" \
                    "$tmpdir/osinstall.py"

                cp "$tmpdir/main.py" main.py.new
                cp "$tmpdir/stub.py" stub.py.new
                cp "$tmpdir/osinstall.py" osinstall.py.new

                mv main.py.new main.py
                mv stub.py.new stub.py
                mv osinstall.py.new osinstall.py

                echo "Installer files updated successfully."
                echo "Updating Distributions.."
                curl -fL --retry 3 \
                    "https://raw.githubusercontent.com/ImAtomiskk/asahim5/main/asahi-installer/installer_data.json" \
                    -o "$tmpdir/installer_data.json"
                cp "$tmpdir/installer_data.json" installer_data.json.new
                mv installer_data.json.new installer_data.json
                break
                ;;
            [Nn]* )
                continue
                ;;
            * )
                echo "Invalid response. Please enter y or n."
                ;;
        esac
    done
    while true; do
        read -r -p "Do you want to enable Update Checking? (y/n)" response
            case "$response" in
            [Yy]* )
                 curl -fL --retry 3 \
                    "https://raw.githubusercontent.com/ImAtomiskk/asahim5/main/asahi-installer/install.sh" \
                    -o "$tmpdir/install.sh"
                cp "$tmpdir/install.sh" install.sh.new
                mv install.sh.new install.sh
                echo "Checking Enabled."
                break
                ;;
            [Nn]* )
                continue
                ;;
            * )
                echo "Invalid response. Please enter y or n."
                ;;
        esac
    done
    while true; do
        read -r -p "Do you want to launch now? (y/n): " response

        case "$response" in
            [Yy]* )
                if [ -e /sys ]; then
                    echo "The installer was downloaded and patched successfully."
                    echo "Installation cannot continue through this Linux path."
                    echo "Copy the generated installer to the target Mac,"
                    echo "review the M5 patches, and launch it from macOS."
                    echo "Install location: $Install"
                    exit 0
                elif [ -e /System ]; then
                        echo "Launching.."
                        echo "Testing Purposes Only"
                    if [ "$USER" != "root" ]; then
                        echo "The installer needs to run as root."
                        echo "Please enter your sudo password if prompted."
                        exec caffeinate -dis sudo REPO_BASE=$REPO_BASE ./install.sh "$@"
                    else
                        exec caffeinate -dis REPO_BASE=$REPO_BASE ./install.sh "$@"
                    fi
                else
                    echo "You appear to be running this script from Windows."
                    echo "Asahi Linux can only be installed from macOS, or downloaded on Linux"
                    exit 0
                fi


                break
                ;;
            [Nn]* )
                exit 0
                ;;
            * )
                echo "Invalid response. Please enter y or n."
                ;;
        esac
    done
    exit 0
fi
