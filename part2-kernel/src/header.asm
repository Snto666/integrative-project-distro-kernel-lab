section .multiboot_header
header_start:
    dd 0xe85250d6                ; Número mágico Multiboot2
    dd 0                         ; Arquitectura: i386 protegido
    dd header_end - header_start ; Longitud de la cabecera
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start)) ; Checksum
    dw 0                         ; Tipo
    dw 0                         ; Flags
    dd 8                         ; Tamaño
header_end:
