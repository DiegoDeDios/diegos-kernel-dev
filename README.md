# Getting Started
## Pre-requirements
Install qemu emulator and nasm assembler:

```bash
sudo apt-get install qemu nasm
```

## Compiling the bootloader

```bash
nasm -f bin boot.asm -o boot.bin
```

## Executing in QEMU

```bash
qemu-system-x86_64 -fda boot.bin   
```