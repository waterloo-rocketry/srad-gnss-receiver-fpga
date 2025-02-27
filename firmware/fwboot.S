.global _start
.section .text.start, "ax", @progbits

.skip 0x80, 0x0

_start:
	li sp, 0x40010000
	j fwmain
