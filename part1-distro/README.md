# Part 1 — Custom Distro with Cubic

# Responsible team member: Esteban Trujillo
# Project: Integrative Project — Operating Systems / Linux (UIDE)

---

## 1. Distro name and base used

- Distro name: LinuxDistro2026
- Linux base: Ubuntu 24.04.4 LTS (Desktop, amd64)
- Build tool: Cubic (Custom Ubuntu ISO Creator)
- ISO compression: XZ

---

## 2. Modifications made (with justification)

### 2.1. Firefox ESR (instead of LibreWolf)

The originally planned modification was to install **LibreWolf** as an alternative browser. However, during the build process the official LibreWolf repository (`deb.librewolf.net`) returned a **404 error** when attempting to download the package for this Ubuntu version, which prevented the installation from completing inside Cubic's chroot environment.

As a functional and justified alternative, **Firefox ESR (Extended Support Release)** was installed instead. It serves the same purpose of offering a browser option different from the one Ubuntu ships by default (Firefox via Snap), with an extended support cycle focused on stability.

- Confirmed version: `Mozilla Firefox 140.12.0esr`
- Terminal verification: `firefox-esr --version`
- Visual verification: **Help → About Firefox** menu, which explicitly shows "Extended Support Release" and the `esr` suffix in the version number — confirming it is distinct from Ubuntu's preinstalled Firefox Snap.

# Technical note: In the test environment (a nested VM in VirtualBox), both `firefox-esr` and `code` require the `--no-sandbox` flag to open their graphical interface. This is because the Chromium/Electron sandbox needs to create *user namespaces*, which the hypervisor's kernel restricts in this nested virtualization setup (`CanCreateUserNamespace() failure: EACCES`). This is not an installation failure, but a known limitation of the test environment.

### 2.2. Visual Studio Code

Visual Studio Code was installed as an integrated development environment, given its relevance for programming tasks in the course.

- Confirmed version: `1.125.1`
- Terminal verification: `code --version`
- Visual verification: full interface opened (File/Edit/Selection/View/Go/Run menus, working Chat/Agent panel).

### 2.3. `/etc/skel` customization

`/etc/skel` was modified so that every new user created on the system automatically inherits:

- A green-colored terminal prompt, formatted as `user@distrogrupo:~$`
- Custom aliases: `actualizar` (equivalent to `sudo apt update && sudo apt upgrade`) and `limpiar` (equivalent to `sudo apt autoremove && sudo apt autoclean`)

This is a persistent customization, since it is built into the system's user-creation template, not just into the active session.

---

## 3. ISO download link

Download ISO: https://www.mediafire.com/file/re78v8tph8yrskh/ubuntu-24.04.4-2026.06.19-desktop-amd64.iso/file

> The ISO is not included in this GitHub repository due to its size (5.68 GiB), which exceeds GitHub's allowed limit.

- File: `ubuntu-24.04.4-2026.06.19-desktop-amd64.iso`
- Size: 5.68 GiB

---

## 4. MD5 hash

```
933eae0bc079cb658d0ae42e78521777
```

Generated automatically by Cubic during the ISO creation process. Verify after downloading with:

```bash
md5sum ubuntu-24.04.4-2026.06.19-desktop-amd64.iso
```

The result must match the hash above exactly to confirm the download was not corrupted.

---

## 5. Instructions to boot the ISO

### In VirtualBox

1. Create a new VM: New - Type: Linux, Version: Ubuntu (64-bit)
2. Recommended RAM: 4096 MB (minimum 2048 MB)
3. In Settings - Storage, mount the downloaded `.iso` file on the IDE/SATA controller (optical drive)
4. In Settings - System - Motherboard, confirm the optical drive is enabled and prioritized in the boot order, before the hard disk
5. Start the VM. In the GRUB menu, select "Try or Install Ubuntu"
6. Wait for the live desktop to load

### In QEMU

```bash
qemu-system-x86_64 \
  -m 4096 \
  -cdrom ubuntu-24.04.4-2026.06.19-desktop-amd64.iso \
  -boot d \
  -enable-kvm
```

---

## 6. Screenshots

Located in `screenshots/`:

| File | Description |
|---|---|
| `boot.png` | Welcome desktop after the ISO boots |
| `desktop-firefox-esr.png` | "About Firefox" window confirming Extended Support Release, version 140.12.0esr |
| `vscode.png` | Visual Studio Code open and functional |
| `terminal-prompt.png` | Terminal showing the custom green prompt `user@distrogrupo:~$` |

---

## Demo video

Watch video: [PENDING — paste video link here, ≤5 minutes]

The video shows, live, in order:
1. Booting the ISO (from boot to desktop)
2. Opening Firefox ESR, confirming it is not the regular Firefox
3. Opening Visual Studio Code
4. Terminal showing the custom green prompt

---

## Directory structure

```
part1-distro/
├── README.md
├── checksum.md5
└── screenshots/
    ├── boot.png
    ├── desktop-firefox-esr.png
    ├── vscode.png
    └── terminal-prompt.png
```
