#!/usr/bin/env bash
# Wait for an Apple Mac in DFU mode, then launch an idevicerestore erase restore.
# Default USB ID is based on the M5 Mac shown by lsusb: 05ac:f014.
set -Eeuo pipefail

usage() {
    echo "Usage: $0 /path/to/Restore.ipsw"
    echo "Optional: DFU_USB_ID=05ac:f014 $0 /path/to/Restore.ipsw"
}

if [[ $# -ne 1 ]]; then
    usage
    exit 2
fi

IPSW=$1
DFU_USB_ID=${DFU_USB_ID:-05ac:f014}

if [[ ! -f "$IPSW" ]]; then
    echo "ERROR: IPSW file not found: $IPSW" >&2
    exit 2
fi

if ! command -v lsusb >/dev/null 2>&1; then
    echo "ERROR: lsusb not found. Install the usbutils package first." >&2
    exit 2
fi
if ! command -v idevicerestore >/dev/null 2>&1; then
    echo "ERROR: idevicerestore not found in PATH." >&2
    exit 2
fi

IPSW=$(realpath -- "$IPSW")

cat <<WARNING
WARNING: This script will run an ERASE restore:
  sudo idevicerestore -e -d "$IPSW"

An erase restore can delete data on the connected Mac. It is not a data-preserving
DFU Revive. Make sure the IPSW is intended for your exact Mac model.

The script will wait for USB DFU ID $DFU_USB_ID and then launch the restore once.
Press Ctrl+C to cancel at any time before the restore starts.
WARNING
read -r -p 'Type ERASE to confirm and begin waiting for DFU: ' confirmation
if [[ "$confirmation" != "ERASE" ]]; then
    echo "Cancelled; no restore was started."
    exit 0
fi

# Request sudo credentials before waiting, so a password prompt does not delay detection.
sudo -v

is_dfu_present() {
    lsusb -d "$DFU_USB_ID" 2>/dev/null | grep -q .
}

if is_dfu_present; then
    echo "DFU device $DFU_USB_ID is already present."
else
    echo "Waiting for Apple DFU device ($DFU_USB_ID). Press Ctrl+C to cancel..."
    while ! is_dfu_present; do
        sleep 1
    done
    echo "Detected DFU device:"
    lsusb -d "$DFU_USB_ID"
fi

# Refresh sudo timestamp, then attempt the restore exactly once.
sudo -v
echo "Starting idevicerestore. Keep the USB cable connected and do not interrupt power."
set +e
sudo idevicerestore -e -d "$IPSW"
status=$?
set -e

if [[ $status -ne 0 ]]; then
    echo >&2
    echo "Restore command failed (exit $status). The script will not retry automatically." >&2
    echo "A visible lsusb DFU entry does not guarantee this idevicerestore build supports the device's DFU mode." >&2
    exit "$status"
fi

echo "idevicerestore exited successfully. Verify the Mac completes setup and boots normally."

