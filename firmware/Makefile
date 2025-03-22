OBJS := \
    fwboot.o \
	fwmain.o \
    libc/string.o \
	canlib/util/can_rcv_buffer.o \
	canlib/util/can_tx_buffer.o \
	canlib/util/safe_ring_buffer.o \
	canlib/mcp2515/mcp_2515.o \
	canlib/message/msg_actuator.o \
	canlib/message/msg_common.o \
	canlib/message/msg_general.o \
	canlib/message/msg_gps.o \
	canlib/message/msg_recovery.o \
	canlib/message/msg_sensor.o \
	canlib/message/msg_state_est.o

CFLAGS := \
    -DBOARD_TYPE_UNIQUE_ID=BOARD_TYPE_ID_SRAD_GNSS \
    -DBOARD_INST_UNIQUE_ID=BOARD_INST_ID_GENERIC \
    -Ilibc \
    -Icanlib

.PHONY: all
all: fw-text.hex fw-data.hex

fw-text.hex: fw-text.bin
	../flows/bin2hex.py fw-text.bin fw-text.hex

fw-text.bin: fw.elf
	riscv32-elf-objcopy -O binary --only-section=.text fw.elf fw-text.bin

fw-data.hex: fw-data.bin
	../flows/bin2hex.py fw-data.bin fw-data.hex

fw-data.bin: fw.elf
	riscv32-elf-objcopy -O binary --only-section=.data fw.elf fw-data.bin

fw.elf: $(OBJS) firmware.ld
	riscv32-elf-ld -T firmware.ld $(OBJS) -o fw.elf

fwboot.o: fwboot.S
	riscv32-elf-as fwboot.S -o fwboot.o -march=rv32im -mabi=ilp32

%.o: %.c
	riscv32-elf-gcc $(CFLAGS) -c $< -o $@ -O2 -U__STDC_HOSTED__ -march=rv32im -mabi=ilp32

.PHONY: clean
clean:
	rm -rf *.o canlib/util/*.o canlib/mcp2515/*.o canlib/message/*.o *.elf *.bin *.hex
