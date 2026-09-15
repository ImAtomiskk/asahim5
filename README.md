# M5 Linux Bringup (Asahi Aperture)

Apple M5 (T8142 "Hidra") — personal Linux bringup project.  
Progressed with Trial & Error, Documented By Myself :D

## Note: No Reverse Engineering Files will Be Released on this Repository. (i don't know how to make those yet)
## Note 2: if i accidentally do something that asahi doesn't want, i'll remove it immediately
## Note 3: I've only tried this on macOS 26.0.1, it will not work on any macOS version that introduced mBoot (26.4+)

## Why? Apple is Discontinuing Rosetta/2 in future macOS releases (macOS 27, 28, etc.) and I still want a chance to run "Intel" apps

## Files (All Files are **exactly** the same ones that I use/test on my own M5)

| File/Folder           | Contents                                                                 |
|-----------------------|--------------------------------------------------------------------------|
| `autoupdate.sh`       | Automatic Updater for This Git Repository (NOTE: THIS DOES NOT WORK YET) |
| `readme.md`           | This File                                                                |
| `progress.md`         | Checklist, roadmap, end goals                                            |
| `soc.md`              | T8142 SoC info, lineage, driver status table, compatible string strategy |
| `proxy-hypervisor.md` | Proxy mode status, zeros problem, hypervisor mode setup                  |
| `drivers.md`          | Driver strategy, RE approach, per-subsystem notes                        |
| `unrelated.md`        | Other things that happened during this process                           |
| `installation.md`     | Installation Steps I Took to Install m1n1                                | 
| `recovery.md`         | Recovery Instructions                                                    |
| `m1n1`                | m1n1 Source Folder                                                       | 
| `m1n1-bak`            | m1n1 Source Backup                                                       |
| `u-boot`              | u-Boot Bootloader Source Folder                                          |
| `notes`               | All of My Notes (Files Above)                                            |
| `dump`                | dumped device trees                                                      |


## Most Recent Achievement

Added M5 MCC Compatibility via TrustZone Registers

## Current Blocker

Nothing rn, just thinking what to do

## Quick Reference

- SoC: T8142 / Hidra (base M5, not Pro)
- MoBo: j704
- Closest Asahi target: T8122 (M3 base) or T8132 (M4 base)
- Serial device: `/dev/ttyACM0`
- Proxy env: `export M1N1_PORT=/dev/ttyACM0`
- Have signed macOS 26.0(.1) IPSW saved locally
