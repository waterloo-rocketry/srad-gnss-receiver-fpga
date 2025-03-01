ENTRY(_start)

MEMORY
{	
    bootrom (rx)  : ORIGIN = 0x0, LENGTH = 64K
    sram (rw) : ORIGIN = 0x4000000, LENGTH = 64K
}

SECTIONS
{
	. = ORIGIN(bootrom);
    .text : 
    {
        *(.text.start)
		*(.text)
		*(.srodata)
    }
	. = ORIGIN(sram);
	.data :
	{
		*(.data)
		*(.bss)
		*(.sdata)
		*(.sbss)
	}
	/DISCARD/ :
	{
		*
	}	
}
