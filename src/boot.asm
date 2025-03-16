[BITS 16]
[org 0x7C00]      ; BIOS loads the bootloader at memory address 0x7C00

start:
xor ax, ax
mov ss, ax
mov sp, 0x7C00
mov [boot_dev],dl

int 3

call setupVideoMode_subr

mov si,welcomeMsg
call print_subr

call waitForAscii_subr

hlt

print_subr:
mov ah,0x0E ;teletype function
printlp:
lodsb ;load byte from si into al
cmp al,0
je stp
int 0x10
jmp printlp
stp:
mov al, 0x0D
int 0x10
mov al, 0x0A
int 0x10
ret

setupVideoMode_subr:
mov ah,0x00 ;initialise video mode
mov al,0x03 ;80x25 text mode
int 0x10 ;bios interrupt
ret

waitForAscii_subr:

fetch_keypress:
mov ah,0x00
int 0x16

cmp al,'r'
je reboot

cmp al,'l'
je loadKernel

jmp fetch_keypress

reboot:
int 0x19

loadKernel:
mov si,dbg
call print_subr
call loadKernel_subr
ret

loadKernel_subr:
cli
lgdt [gdt_descriptor]
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7C00
sti

xor ax, ax
mov dl, [boot_dev]
int 0x13
jc errorHndl

mov ah, 0x02
mov al,1
mov ch,0
mov cl,2
mov dh,0
mov dl,[boot_dev]
mov bx,0x1000
mov es,bx
mov bx, 0x0000
int 0x13
jc errorHndl

cli
lgdt [gdt_descriptor]

mov eax, cr0
or eax, 1
mov cr0, eax

jmp CODE_SEG:pmode

errorHndl:
mov si,error
call print_subr

ret

;Data
welcomeMsg db "Bootloader initialised, press l to proceed or r to reboot",0
dbg db "Loading kernel into Memory",0
error db "an Error has occurred",0
boot_dev db 0

gdt_start:

gdt_null:
    dd 0x00000000   ; Lower 32 bits
    dd 0x00000000   ; Upper 32 bits

gdt_code:
    dw 0xFFFF       ; Limit (bits 0-15)
    dw 0x0000       ; Base (bits 0-15)
    db 0x00         ; Base (bits 16-23)
    db 0x9A         ; Access byte: Present(1), Ring 0(00), Code(1), Executable(1), Readable(0), Accessed(0) = 10011010b
    db 0xCF         ; Flags: Granularity(1, 4KB), 32-bit(1), Limit (bits 16-19: 1111b) = 11001111b
    db 0x00         ; Base (bits 24-31)

gdt_data:
    dw 0xFFFF       ; Limit (bits 0-15)
    dw 0x0000       ; Base (bits 0-15)
    db 0x00         ; Base (bits 16-23)
    db 0x92         ; Access byte: Present(1), Ring 0(00), Data(0), Writable(1), Accessed(0) = 10010010b
    db 0xCF         ; Flags: Granularity(1, 4KB), 32-bit(1), Limit (bits 16-19: 1111b) = 11001111b
    db 0x00         ; Base (bits 24-31)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

[BITS 32]
pmode:

mov ax, DATA_SEG
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax
mov esp, 0x9000

jmp 0x10000

times 510-($-$$) db 0
dw 0xAA55              ; Boot signature
