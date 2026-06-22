void kernel_main() {
    // Puntero a la memoria de video VGA
    char *video_memory = (char *) 0xb8000;

    // Mensaje del grupo
    const char *str = "KERNEL 64-BIT: SANTIAGO, ESTEBAN, DANIEL, BRYAN";

    // 0x0A es el código hexadecimal para color verde brillante
    unsigned char color = 0x0A; 

    for (int i = 0; str[i] != '\0'; i++) {
        // El primer byte es el carácter
        video_memory[i * 2] = str[i];
        // El segundo byte es el atributo de color
        video_memory[i * 2 + 1] = color;
    }
}
