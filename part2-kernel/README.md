# Part 2 — Custom 64-bit Kernel (SYGRUB)

> Integrative Project: *Build, Boot, and Attack*
> Universidad Internacional del Ecuador (UIDE) — Systems Engineering
> Instructor: Ing. Jonathan E. Tito O., MSc.

A freestanding 64-bit x86 kernel built from scratch in NASM and C, booted via GRUB through the Multiboot2 protocol. The kernel performs full CPU capability checks, transitions the processor from 32-bit protected mode into 64-bit long mode, sets up paging and a custom GDT, and prints a formatted message directly to VGA text-mode memory.

---

## 1. Overview

This kernel demonstrates the complete boot chain of a minimal x86_64 operating system, without relying on any existing kernel or libc:

- **Multiboot2-compliant** header so GRUB can recognize and load the binary.
- **Hardware capability verification** for Multiboot, CPUID, and Long Mode support before attempting the 64-bit transition.
- **Identity-mapped paging** covering the first gigabyte of memory using huge pages.
- **Custom 64-bit Global Descriptor Table (GDT)** to enable the segment switch into long mode.
- **C-language kernel core** with a small VGA text-mode driver (`clear_screen`, `set_color`, `print_str`) that renders the team's identification message in bright green on boot.
- **Custom GRUB boot entry**, branded `SYGRUB Kernel 64-bit`, in place of a generic bootloader label.

The build is fully reproducible: a Docker image bundles the exact toolchain (NASM, GCC cross-compiler, GRUB tools, xorriso) so the kernel compiles identically on any machine with Docker installed, with no host dependencies beyond that.

---

## 2. Boot Demonstration

| | |
|---|---|
| **Bootloader label** | `SYGRUB Kernel 64-bit` |
| **Boot message** | `KERNEL 64-BIT: SANTIAGO, ESTEBAN, DANIEL, BRYAN` |
| **Text color** | Bright green (VGA attribute byte `0x0A`) on black background |
| **Emulator** | QEMU (`qemu-system-x86_64`) |

📹 **Demo video:** [VIdeo_explicativo_kernel.mp4](https://www.mediafire.com/file/03857ojse3hzt4p/VIdeo_explicativo_kernel.mp4/file)

The video shows the Docker build completing, `kernel.iso` being generated, and the kernel booting end-to-end in QEMU with the GRUB menu and the final green boot message. Runtime complies with the assignment's ≤ 2-minute limit for Part 2.

---

## 3. Technical Implementation

### 3.1 Boot flow

**Episode 1 milestone (intermediate verification):** the initial boot path was validated by writing directly to VGA memory address `0xb8000` to print `OK`, confirming that the Multiboot2 header was valid and GRUB successfully handed control to the kernel in 32-bit mode. This was the first successful QEMU boot of the project.

**Episode 2 (final implementation):** the `OK` checkpoint was then extended into the full long-mode transition described below. The final `kernel.iso` supersedes the Episode 1 output — instead of stopping at `OK`, execution continues through paging, the GDT switch, and into the C kernel, ending in the formatted team message. Both milestones were therefore achieved sequentially; only the final, more complete output ships in the submitted binary.

Unlike a typical multi-file split between boot checks and long-mode entry, this implementation consolidates the full 32-bit boot sequence into a single assembly file (`main.asm`), which performs the following steps in order:

1. Validate that the kernel was loaded by a Multiboot2-compliant bootloader (magic value check on `eax`).
2. Verify CPUID is supported by attempting to flip the ID bit in the `EFLAGS` register.
3. Verify Long Mode (IA-32e) is supported via extended CPUID function `0x80000001`.
4. Build identity-mapped page tables (PML4 → PDPT → PD) covering the first 1 GB of physical memory, using 2 MB huge pages to avoid needing a separate page table level.
5. Enable PAE, load `CR3` with the page table base, and set the Long Mode Enable (LME) bit in the `EFER` MSR.
6. Enable paging via `CR0`.
7. Load the 64-bit GDT and perform a far jump into the 64-bit code segment, transferring control to `long_mode_start`.

### 3.2 GDT and long mode entry

The GDT defines a minimal null descriptor plus a 64-bit code segment descriptor. After the far jump, `long_mode_start` (in `long_mode.asm`) clears the legacy segment registers and calls into the C entry point, `kernel_main`.

### 3.3 C kernel core (`kernel.c`)

The C layer implements a minimal freestanding VGA driver — no libc, no stack protector, no red zone — matching the constraints of code running with no underlying OS:

```c
void kernel_main() {
    clear_screen();
    set_color(0x0A);  // Bright green on black
    print_str("KERNEL 64-BIT: SANTIAGO, ESTEBAN, DANIEL, BRYAN\n");
}
```

The VGA color attribute byte `0x0A` was chosen deliberately over the default `0x0F` (white on black) to give the boot screen a classic green-phosphor terminal aesthetic.

### 3.4 GRUB configuration

`grub.cfg` defines a single boot entry, renamed from the generic tutorial default to a project-branded label:

```cfg
menuentry "SYGRUB Kernel 64-bit" {
    multiboot2 /boot/kernel.bin
    boot
}
```

---

## 4. Directory Structure

```
part2-kernel/
├── Dockerfile              # Reproducible build environment (NASM, GCC cross, GRUB, xorriso)
├── Makefile                # Build automation (assembly → ELF → ISO)
├── README.md                # This file
├── kernel.iso                # Final bootable image
├── src/
│   ├── header.asm           # Multiboot2 header
│   ├── main.asm              # 32-bit entry point: boot checks, paging, GDT load, long mode jump
│   ├── long_mode.asm        # 64-bit entry: segment cleanup, call into C
│   └── kernel.c              # VGA driver + kernel_main (boot message)
└── targets/x86_64/
    ├── linker.ld              # Linker script (load address, section layout)
    └── grub.cfg                # GRUB menu definition (SYGRUB entry)
```

Build artifacts (`*.o`, `kernel.bin`) are not committed — only the final `kernel.iso` and source files are version-controlled, per the project's repository cleanliness guidelines.

---

## 5. Build & Run Instructions

### Prerequisites

- Docker installed and running.
- QEMU (`qemu-system-x86_64`) installed on the host to test the ISO.

### Build

From the `part2-kernel/` directory:

```bash
docker build -t kernel-builder .
make
```

This compiles all assembly and C sources inside the containerized toolchain and produces `kernel.iso` in the project root.

### Run

```bash
qemu-system-x86_64 -cdrom kernel.iso
```

Expected result: the `SYGRUB Kernel 64-bit` GRUB entry appears briefly, then the kernel boots into 64-bit long mode and displays the message `KERNEL 64-BIT: SANTIAGO, ESTEBAN, DANIEL, BRYAN` in bright green on a black screen.

### Clean

```bash
make clean
```

Removes all object files, the kernel binary, and the generated ISO.

---

## 6. Team

| Member | Role |
|---|---|
| Santiago Yambay | Group lead — Part 2: 64-bit Kernel |
| Esteban Trujillo | Part 1: Custom Distro (Cubic) |
| Daniel Villareal | Part 3: Black Hat Bash Offensive Lab |
| Bryan | Contributor — Part 2 support |

---

## 7. References

- Tutorial reference: *Write Your Own 64-bit Operating System Kernel* (Multiboot2 header, long mode transition, paging, and C integration).
- Multiboot2 Specification — GNU GRUB documentation.
