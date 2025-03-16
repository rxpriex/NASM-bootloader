# Makefile for Assembly Bootloader

# Variables
ASM = nasm
QEMU = qemu-system-i386
BUILD_DIR = build
SOURCE_DIR = src
OUTPUT = $(BUILD_DIR)/boot.bin

# Default target
all: $(OUTPUT)
	@echo "Build complete. Run with 'make run' to test."

# Rule to assemble the bootloader
$(OUTPUT): $(SOURCE_DIR)/boot.asm
	@mkdir -p $(BUILD_DIR)
	$(ASM) -f bin $(SOURCE_DIR)/boot.asm -o $(OUTPUT)
	@echo "Assembled $(OUTPUT)"

# Rule to assemble the kernel
$(KERNEL): $(SOURCE_DIR)/kernel.asm
	$(ASM) -f bin $(SOURCE_DIR)/kernel.asm -o $(KERNEL)
	@echo "Assembled $(KERNEL)"

# Rule to run the bootloader in QEMU
run: $(OUTPUT)
	$(QEMU) -fda $(OUTPUT)

# Clean up build files
clean:
	@rm -rf $(BUILD_DIR)
	@echo "Cleaned build directory"

# Phony targets (not files)
.PHONY: all run clean