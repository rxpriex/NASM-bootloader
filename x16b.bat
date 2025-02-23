@echo off
del *.bin *.img
nasm -f bin boot.asm -o boot.bin
dd.exe if=/dev/zero of=floppy.img bs=512 count=2880
dd.exe if=boot.bin of=floppy.img conv=notrunc
