# M5 Linux Bringup Notes

Apple M5 (T8142 "Hidra") — personal Linux bringup project.  
Progressed with Trial & Error, Documented By Claude.

## Note: No Reverse Engineering Files will Be Released on this Repository. (i don't know how to make those)

## Files

| File                  | Contents                                                                 |
|-----------------------|--------------------------------------------------------------------------|
| `progress.md`         | Checklist, roadmap, end goals                                            |
| `soc.md`              | T8142 SoC info, lineage, driver status table, compatible string strategy |
| `proxy-hypervisor.md` | Proxy mode status, zeros problem, hypervisor mode setup                  |
| `drivers.md`          | Driver strategy, RE approach, per-subsystem notes                        |
| `unrelated.md`        | Other things that happened during this process                           |
| `installation.md`     | Installation Steps I Took to Install m1n1                                | 

## Current Blocker

Nothing rn, just thinking what to do

## Quick Reference

- SoC: T8142 / Hidra (base M5, not Pro)
- MoBo: j704
- Closest Asahi target: T8122 (M3 base)
- Serial device: `/dev/ttyACM0`
- Proxy env: `export M1N1_PORT=/dev/ttyACM0`
- Have signed macOS 26.0 IPSW saved locally
