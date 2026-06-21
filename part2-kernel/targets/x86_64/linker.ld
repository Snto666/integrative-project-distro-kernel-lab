ENTRY(start)
SECTIONS {
    . = 1M;
    .boot :
    {
        /* Multiboot header primero */
        KEEP(*(.multiboot_header))
    }
    .text :
    {
        *(.text)
    }
}
