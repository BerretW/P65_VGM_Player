.include "io.inc65"
.include "macros_65C02.inc65"

.zeropage
song_addr:			.res 2
_song_pos:			.res 2
.smart		on
.autoimport	on
.case		on
.debuginfo	off
.importzp	sp, sreg, regsave, regbank
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack	longbranch


.export _ym_write_data
.export _ym_write_reg
.export _ym_write_data_A1
.export _ym_write_reg_A1
.export _ym_init
.export _delay
.export _ym_setreg
.export _ym_setreg_A1
.export _getBytes
.export _set_song_pos
.export _song_pos
.export _play_song_from_bank
.export _init_read
.import _acia_putc


.data

.code

_play_song_from_bank:	STA BANK_BASE
									ldy #$00
									lda (sp),y
									STA _song_pos
									ldy #$01
									lda (sp),y
									STA _song_pos+1
									jmp incsp2

_set_song_pos:
						STA _song_pos
						LDA #0
						STA _song_pos + 1
						STX _song_pos + 1
						RTS
_ym_setreg:
            jsr pusha
            ldy #$01
            lda (sp),y
            JSR _ym_write_reg
            ;jsr _delay
            LDY #$00
            LDA (sp),y
            JSR _ym_write_data
            jmp incsp2

_ym_setreg_A1:
            jsr pusha
            ldy #$01
            lda (sp),y
            JSR _ym_write_reg_A1
            ;jsr _delay
            LDY #$00
            LDA (sp),y
            JSR _ym_write_data_A1
            jmp incsp2
_ym_init:
            LDA #$FF
            STA VIA_DDRA
            STA VIA_DDRB
            LDA #%11111100
            STA VIA_ORB
            jsr _delay
            LDA #%11111000
            STA VIA_ORB
            jsr _delay2
            jsr _delay2
            LDA #%11111100
            STA VIA_ORB
            RTS

_ym_write_data:
            PHA
            LDX #%11110101
            STX VIA_ORB
            ;jsr _delay
            PLA
            STA VIA_ORA
            ;JSR _delay
            LDX #%11010101
            STX VIA_ORB
            ;jsr _delay
            LDX #%11110101
            STX VIA_ORB
            ;jsr _delay
            LDX #%11111100
            STX VIA_ORB
            RTS
_ym_write_data_A1:
            PHA
            LDX #%11110111
            STX VIA_ORB
            ;jsr _delay
            PLA
            STA VIA_ORA
            ;JSR _delay
            LDX #%11010111
            STX VIA_ORB
            ;jsr _delay
            LDX #%11110111
            STX VIA_ORB
            ;jsr _delay
            LDX #%11111100
            STX VIA_ORB
            RTS

_ym_write_reg:  PHA
                LDX #%11110100
                STX VIA_ORB
                ;jsr _delay
                PLA
                STA VIA_ORA
                ;jsr _delay
                LDX #%11010100
                STX VIA_ORB
                ;jsr _delay
                LDX #%11110100
                STX VIA_ORB
                ;jsr _delay
                LDX #%11111100
                STX VIA_ORB
                RTS
_ym_write_reg_A1:   PHA
                    LDX #%11110110
                    STX VIA_ORB
                    ;jsr _delay
                    PLA
                    STA VIA_ORA
                  ;  jsr _delay
                    LDX #%11010110
                    STX VIA_ORB
                    ;jsr _delay
                    LDX #%11110110
                    STX VIA_ORB
                    ;jsr _delay
                    LDX #%11111100
                    STX VIA_ORB
                    RTS

; ---------------------------------------------------------------
; void __near__ init_read (char *data)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_init_read: near

.segment	"CODE"
_init_read:
						;STA ACIA_DATA
						;STX ACIA_DATA

						STA _song_pos
						STX _song_pos+1
						RTS

.endproc
; ---------------------------------------------------------------
; char __near__ getBytes (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_getBytes: near

.segment	"CODE"
_getBytes:  	;LDA _song_pos
							;STA ACIA_DATA
							;LDA _song_pos+1
							;STA ACIA_DATA

							;LDX #0
							LDA (_song_pos)
							;STA ACIA_DATA

							LDX _song_pos
							INX
							STX _song_pos
							BNE _end
							LDY _song_pos+1
							INY
							STY _song_pos+1
							BNE _end
							INC BANK_BASE
							LDA #0
							STA _song_pos
							LDA #$80
							STA _song_pos + 1
_end:					RTS

.endproc




_delay:					TAY
								INX
								;LDX #1
								;LDY #1
_delay1:				DEY
                BNE _delay1
_delay2:				DEX
								BNE _delay1
_dend:           RTS

__delay2:				LDX #$FF
__delay3:				DEX
                BNE __delay3
                RTS
