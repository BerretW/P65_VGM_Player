.include "io.inc65"
.include "macros_65C02.inc65"

.zeropage


.smart		on
.autoimport	on
.case		on
.debuginfo	off
.importzp	sp, sreg, regsave, regbank
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack	longbranch

.export _format_bank
.export _write_to_BANK
.export _switch_bank
.export _set_bank

.code



_set_bank:
					STA BANKDISK
					RTS

_format_bank:     	LDY #0
					LDA #<(BANKDISK)
					LDX #>(BANKDISK)
					STA ptr1
					STX ptr1 + 1

@write_BANK:		LDA #$0
					STA (ptr1), Y
					INY
					CPY #$0
					BNE @end_BANK
					INX
					STX ptr1 + 1
					CPX #$C0
					BNE @end_BANK
					RTS
@end_BANK:			JMP @write_BANK

_write_to_BANK:
					LDY #0
					LDA #<(BANKDISK)
					LDX #>(BANKDISK)
					STA ptr1
					STX ptr1 + 1

@write_BANK:		JSR _acia_getc
					;JSR _lcd_putc
					STA (ptr1), Y
					INY
					CPY #$0
					BNE @end_BANK
					INX
					STX ptr1 + 1
					CPX #$C0
					BNE @end_BANK
          INC BANK_BASE
					JMP _write_to_BANK
@end_BANK:			JMP @write_BANK


_switch_bank: INC BANK_BASE
              RTS
