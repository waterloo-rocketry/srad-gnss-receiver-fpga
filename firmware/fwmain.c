#include <stdint.h>

struct GPIORegs {
    volatile uint32_t gpio_out_value;
    volatile uint32_t gpio_out_enable;
    volatile uint32_t gpio_in_data;
} *const gpio_regs = (struct GPIORegs *)0x80000000;

unsigned int fib(unsigned int n) {
    if (n == 0) {
        return 0;
    } else if (n == 1) {
        return 1;
    } else {
        return fib(n - 1) + fib(n - 2);
    }
}

void fwmain(void) {
    gpio_regs->gpio_out_enable = 1;
    for (int i = 0; i < 10; i++) {}
    gpio_regs->gpio_out_value = 1;
    for (int i = 0; i < 10; i++) {}
    gpio_regs->gpio_out_value = 2;
    for (int i = 0; i < 10; i++) {}
    gpio_regs->gpio_out_value = 4;
    for (int i = 0; i < 10; i++) {}
    gpio_regs->gpio_out_value = fib(18);
    for (;;) {}
}
