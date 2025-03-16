# Bootloader Project
A custom x86 bootloader written in Assembly, demonstrating BIOS interrupts, GDT setup, and mode switching.

## Description
This bootloader initializes in 16-bit real mode, sets up a text mode, prints a welcome message, and attempts to load a kernel into memory. It supports rebooting ('r') or loading a kernel ('l').

## Build Instructions
1. Install MSYS2 and NASM: `pacman -S mingw-w64-x86_64-nasm`.
2. Assemble the bootloader: `nasm -f bin src/boot.asm -o build/boot.bin`.
3. Install QEMU: `pacman -S mingw-w64-x86_64-qemu`.
4. Run in QEMU: `qemu-system-i386 -fda build/boot.bin`.

## Demo
![Bootloader Demo](https://example.com/bootloader.gif)