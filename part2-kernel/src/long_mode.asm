global long_mode_start
extern kernel_main

section .text
bits 64
long_mode_start:
    ; Cargar registros de datos nulos para evitar errores de segmento
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Llamar a nuestra función escrita en C
    call kernel_main
    hlt
