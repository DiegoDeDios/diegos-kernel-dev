; Author Diego de Dios. Adapted from C++ code from: https://www.apriorit.com/dev-blog/66-develop-boot-loader 
bits 16; Will use 16 bit mode addressing

org 0x7c00

boot:
    mov si, startup; loading start message address to source index register: http://www.baskent.edu.tr/~tkaracay/etudio/ders/prg/pascal/PasHTM2/pas/lowlevel.html#:~:text=The%20register%20SI%20and%20DI,always%20pointed%20to%20the%20destination.
    mov ah, 0x0e; Loading AH with int10h interrupt. Video services TTY mode, since we dont have a video driver written I need to use BIOS interrupt 10h 

.loop:
    lodsb; as x86 assembly defines it: Load byte at address DS:(E)SI into AL
    or al, al
    jz halt; halt if the string has finished printing
    int 0x10; Just like with syscalls bios interrups have coding conventions: https://stanislavs.org/helppc/int_table.html
    jmp .loop ;loop until string is done
halt:
    cli ;clear the interrupt flag
    hlt; halt the cpu execution

startup: db "diegOS", 0

times 510 - ($-$$) db 0; fill the rest of the bootloader with 0x0
dw 0xaa55; The magic number. From wikipedia: he 0xAA55 signature is the last two bytes of the first sector of your bootdisk (bootsector/Master Boot Record/MBR). If it is 0xAA55, then the BIOS will try booting the system. If it's not found (it garbled or 0x0000), you'll get an error message from your BIOS that it didn't find a bootable disk (or the system tries booting the next disk)