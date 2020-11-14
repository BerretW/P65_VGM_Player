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


.export _ym_write_data
.export _ym_write_reg
.export _ym_write_data_A1
.export _ym_write_reg_A1
.export _ym_init
.export _delay
.export _ym_setreg
.export _ym_setreg_A1
.export _getByte
.export _getBytes
.export _set_song_pos
.export _song_pos
.export _play_song_from_bank

.import _acia_putc


.data

_song_pos:
	.word	$0100
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
; char __near__ getBytes (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_getBytes: near

.segment	"CODE"

	inc     _song_pos
	bne     L0002
	inc     _song_pos+1
L0002:	lda     _song_pos+1
	cmp     #$40
	bne     L0003
	lda     _song_pos
	bne     L0003
	stz     _song_pos
	stz     _song_pos+1
	jsr     _switch_bank
L0003:	lda     #<(BANKDISK)
	sta     ptr1
	lda     #>(BANKDISK)
	clc
	adc     _song_pos+1
	sta     ptr1+1
	ldy     _song_pos
	ldx     #$00
	lda     (ptr1),y
	rts

.endproc


; ---------------------------------------------------------------
; char __near__ getByte (char *data)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_getByte: near

.segment	"CODE"

	jsr     pushax
	inc     _song_pos
	bne     L0002
	inc     _song_pos+1
L0002:	lda     _song_posi+1
	cmp     #$40
	bne     L0003
	lda     _song_pos
	bne     L0003
	stz     _song_pos
	stz     _song_pos+1
	jsr     _switch_bank
L0003:	jsr     ldax0sp
	clc
	adc     _song_pos
	sta     ptr1
	txa
	adc     _song_pos+1
	sta     ptr1+1
	lda     (ptr1)
	;jsr     _acia_putc
	jsr     _delay
	jsr     ldax0sp
	clc
	adc     _song_pos
	sta     ptr1
	txa
	adc     _song_pos+1
	sta     ptr1+1
	ldx     #$00
	lda     (ptr1)
	jmp     incsp2

.endproc

_delay:					LDX #$1
_delay1:				DEX
                BNE _delay1
                RTS
_delay2:					LDX #$FF
_delay3:				DEX
                BNE _delay3
                RTS
