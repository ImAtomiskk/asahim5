# M5 Linux Bringup

Apple M5 (T8142 "Hidra") — personal Linux bringup project.  
Progressed with Trial & Error

[![Static Badge](https://img.shields.io/badge/GitHub-ImAtomiskk\AsahiM5-blue?logo=github)](https://github.com/ImAtomiskk/asahim5)  
## Linux: ![](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)
## m1n1: ![](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)

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

(10/03/2026) - Compiled (asahi) Linux Source for M5

## Current Blocker

M5 secondary-core startup or the kernel startup in general

## Quick Reference

- SoC: T8142 / Hidra (base M5, not Pro)
- MoBo: j704
- Closest Asahi target: T8122 (M3 base) or T8132 (M4 base)
- Serial device: `/dev/ttyACM0`
- Proxy env: `export M1N1_PORT=/dev/ttyACM0`
- Have signed macOS 26.0(.1) IPSW saved locally
- Sub-machine: Intel Core i7-11700KF, 32GB Memory, Ubuntu Studio 26.04
