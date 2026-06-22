# Build, Boot, and Attack — Integrative Project

[![Status](https://img.shields.io/badge/status-in%20progress-yellow)]()
[![University](https://img.shields.io/badge/UIDE-Systems%20Engineering-1F5C99)]()

> A full-stack systems engineering project: customizing a Linux distribution, building a 64-bit kernel from scratch, and deploying/attacking a containerized offensive security lab.

**Course:** Integrative Project — Systems Engineering, UIDE
**Instructor:** Ing. Jonathan E. Tito O., MSc.
**Term:** March – July 2026
**Submission deadline:** Tuesday, June 23, 2026 — 23:59

---

## Team

| Member | Role | Part |
|---|---|---|
| **Santiago Yambay** | Group Lead | Part 2 — 64-bit Kernel |
| **Esteban Trujillo** | Member | Part 1 — Custom Linux Distro (Cubic) |
| **Daniel Villareal** | Member | Part 3 — Black Hat Bash Offensive Lab |
| **Bryan Merino** | Member | Support — Part 2 (Kernel) |

---

## Project Overview

This project walks the complete stack of a Linux system — from building a custom distribution, through booting a self-written kernel, to standing up and attacking a containerized security lab — to understand how operating systems are assembled, booted, and broken.

The work is split into three independent, parallel tracks:

```
┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│   PART 1              │     │   PART 2               │     │   PART 3              │
│   Custom Distro      │     │   64-bit Kernel        │     │   Offensive Lab       │
│   (Cubic)            │     │   (NASM/GRUB/C)        │     │   (Black Hat Bash)   │
│                       │     │  Bryan Merino                     │     │                       │
│   Esteban Trujillo   │     │   Santiago Yambay      │     │   Daniel Villareal    │
└─────────────────────┘     └─────────────────────┘     └─────────────────────┘
```

---

## Repository Structure

```
integrative-project-distro-kernel-lab/
├── README.md                  ← You are here
├── .gitignore
├── part1-distro/              ← Esteban Trujillo
│   ├── README.md
│   ├── checksum.md5
│   └── screenshots/
├── part2-kernel/              ← Santiago Yambay
│   ├── README.md
│   ├── Dockerfile
│   ├── Makefile
│   ├── kernel.iso
│   ├── src/
│   ├── targets/x86_64/
│   └── screenshots/
└── part3-lab/                 ← Daniel Villareal
    ├── README.md
    └── screenshots/
```

Each part is self-contained: its own README with setup instructions, evidence, and technical write-up. Click into any folder above for the full breakdown.

---

## Part Summaries

### 📀 Part 1 — Custom Distro with Cubic
**→ [`part1-distro/README.md`](./part1-distro/README.md)**

A custom Ubuntu/Linux Mint-based distribution built and repackaged using Cubic. Includes three justified modifications — a browser substitution (Firefox ESR), a preinstalled development environment (Visual Studio Code), and persistent `/etc/skel` customization (custom shell prompt and aliases applied automatically to new users) — packaged into a bootable XZ-compressed ISO and verified in QEMU.

### 🖥️ Part 2 — 64-bit Kernel from Scratch
**→ [`part2-kernel/README.md`](./part2-kernel/README.md)**

A freestanding x86_64 kernel written in NASM and C, booted via GRUB through the Multiboot2 protocol. Performs full hardware capability checks (CPUID, Long Mode support), configures identity-mapped paging, builds a 64-bit GDT, and transitions the processor into long mode — printing a custom message to VGA text memory. Built with a fully reproducible Docker toolchain.

### 🔓 Part 3 — Black Hat Bash Offensive Lab
**→ [`part3-lab/README.md`](./part3-lab/README.md)**

An 8-container Docker lab simulating a segmented corporate network (`172.16.10.0/24` public, `10.1.0.0/24` corporate), deployed and verified end-to-end. Includes reconnaissance and enumeration techniques executed against the team's own isolated environment, each documented with command output and technical interpretation.

> **Note:** as an additional robustness test, the lab was deployed and validated **twice**, in two independent environments — a VirtualBox VM and a Kali Linux installation running directly on a mobile device — confirming the deployment process is portable across host platforms, not just reproducible on a single machine.

---

## Demo Video

> 🎬 **Full project demo (≤ 8 min):** *[link pending — final video in progress]*

The video shows, live and in sequence:
1. The custom ISO booting in QEMU (Part 1)
2. The 64-bit kernel booting in QEMU (Part 2)
3. `make test` confirming the lab is up, followed by the offensive technique demonstration (Part 3)

---

## Technology Stack

| Category | Tools |
|---|---|
| Distro customization | Cubic, Linux Mint / Ubuntu, QEMU |
| Kernel development | NASM, GCC cross-compiler, GRUB, Docker, QEMU |
| Offensive security lab | Docker, Docker Compose, Kali Linux, nmap, WhatWeb, ftp |
| Version control | Git, GitHub |

---

## Reproducing This Project

Each part can be built and run independently. See the linked README in each folder for full instructions. Quick reference:

```bash
# Part 1 — boot the custom distro ISO
qemu-system-x86_64 -cdrom part1-distro/<distro-name>.iso -m 2048 -boot d

# Part 2 — build and boot the kernel
cd part2-kernel
docker build -t kernel-builder .
make
qemu-system-x86_64 -cdrom kernel.iso

# Part 3 — deploy the offensive lab
cd part3-lab/Black-Hat-Bash/lab
sudo make deploy
sudo make test
```

---

## Submission

- **Repository:** `https://github.com/Snto666/integrative-project-distro-kernel-lab`
- **Final commit/tag:** *[to be added once all three parts are complete and merged into `main`]*

---

## Acknowledgments

- *How To Roll Your Own Linux Distro* — Cubic reference guide.
- *Write Your Own 64-bit Operating System Kernel* — kernel development reference.
- *Black Hat Bash*, Dolev Farhi & Nick Aleks — offensive lab reference (Chapter 3).
