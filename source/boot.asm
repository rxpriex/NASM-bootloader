[org 0x7C00]      ; BIOS loads the bootloader at memory address 0x7C00

start:
xor ax, ax     
mov ss, ax     
mov sp, 0x7C00

call setupVideoMode_subr

mov si,welcomeMsg
call print_subr  

push 'p'
call waitForAscii_subr

mov si,dbg
call print_subr

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
push bp
mov bp,sp

sub sp,1
mov al,[bp+4]
mov [bp-1],al

fetch_keypress:
mov ah,0x00
int 0x16

cmp al,[bp-1]
jne fetch_keypress

add sp,1
pop bp

ret

;Data
welcomeMsg db "Bootloader initialised, press p to proceed",0
dbg db "Loading kernel into Memory",0

times 510-($-$$) db 0  
dw 0xAA55              ; Boot signature 
