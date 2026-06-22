all: kernel.iso

kernel.bin: src/header.asm src/main.asm src/long_mode.asm src/kernel.c
	docker run --rm -v $(PWD):/kernel kernel-builder sh -c \
	"nasm -f elf64 src/header.asm -o header.o && \
	nasm -f elf64 src/main.asm -o main.o && \
	nasm -f elf64 src/long_mode.asm -o long_mode.o && \
	gcc -c src/kernel.c -o kernel.o -ffreestanding -m64 -nostdlib -fno-stack-protector -mno-red-zone && \
	ld -n -o kernel.bin -T targets/x86_64/linker.ld header.o main.o long_mode.o kernel.o"

kernel.iso: kernel.bin
	docker run --rm -v $(PWD):/kernel kernel-builder sh -c \
	"mkdir -p iso/boot/grub && \
	cp kernel.bin iso/boot/ && \
	cp targets/x86_64/grub.cfg iso/boot/grub/ && \
	grub-mkrescue -o kernel.iso iso"

clean:
	rm -f *.o kernel.bin kernel.iso
	rm -rf iso/
