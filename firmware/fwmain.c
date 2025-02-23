#include <stdint.h>

struct GPIORegs {
    volatile uint32_t gpio_out_value;
    volatile uint32_t gpio_out_enable;
    volatile uint32_t gpio_in_data;
} *const gpio_regs = (struct GPIORegs *)0x80000000;

void fwmain(void) {
    gpio_regs->gpio_out_enable = 1;
    for (;;) {
        for (int i = 0; i < 100; i++) {}
        gpio_regs->gpio_out_value ^= 1;
    }
}
