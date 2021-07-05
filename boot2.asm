;Author: Diego de Dios. Booting into real mode and switching into protected mode
bits 16
org 0x7c00

boot:

    mov ax, 0x2401
    int 0x15 ; Enable A20 bit... seriously wtf Intel

    mov ax, 0x3
    int 0x10 ; VGA Mode 3

    cli ; clear flags

    lgdt [gdt_pointer]

    ;enabling protected mode
    mov eax, cr0
    or eax, 0x1 ; bit 0 is pe (protected mode enable)
    mov cr0, eax ; move new value to cr0
    jmp CODE_SEG:boot2

; Start of the global descriptor table
gdt_start:
    dq 0x0
gdt_code:
    dw 0xFFFF
    dw 0x0
    dw 0x0
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:
    dw 0xFFFF
    dw 0x0
    dw 0x0
	db 10010010b
	db 11001111b
	db 0x0
gdt_end:
gdt_pointer:
    dw gdt_end - gdt_start
    dd gdt_start
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32 ;entering 32 bit mode
boot2:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esi, hello
    mov ebx, 0xb8000 ; The VGA text buffer is located at physical memory address 0xB8000

.loop:
    lodsb
    or al,al
    jz halt
    or eax, 0x0100
    mov word [ebx], ax
    add ebx, 2
    jmp .loop



halt:
    cli
    hlt

hello: db 'Hello M1',0

times 510 - ($-$$) db 0
dw 0xaa55