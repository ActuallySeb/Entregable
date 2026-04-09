.include "constants.inc"
.include "header.inc"

.segment "ZEROPAGE"
; -- Compression --
Compressed:         .res 60
ID_Block:           .res 4
Y_temp:             .res 1


; --Decompression --
top_half:           .res 32
bottom_half:        .res 32
MXindex:            .res 1
MYindex:            .res 1
bit_loop:           .res 1
index:              .res 1
sleep:              .res 1

.exportzp Compressed, ID_Block, Y_temp, MXindex, MYindex, bit_loop, index, top_half, bottom_half

.segment "CODE"
.import compress, decompress

.proc irq_handler
  RTI
.endproc

.proc nmi_handler

  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
	LDA #$00
	STA $2005
	STA $2005


  RTI
.endproc

.import reset_handler

.export main
.proc main
  ; wait for first vblank
  vblankwait1:
  BIT PPUSTATUS
  BPL vblankwait1
  
  ; write a palette
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR
load_palettes:
  LDA palettes,X
  STA PPUDATA
  INX
  CPX #$20
  BNE load_palettes


  LDX #$00
  LDA 0
@init:
  STA bit_loop
  STA top_half, X
  STA bottom_half, X
  
  INX
  CPX #32
  BNE @init

; CompressBG:
;   LDX #$00
;   LDY #$00
;   STY Y_temp

;   Loop1:
;   JSR SkipRow
;   LDA BackgroundData, X
  
;   JSR compress_check

;   CPX #224   ; Offset to first tile in final row
;   BNE Loop1

;   Loop2:
;   JSR SkipRow
;   LDA BackgroundData+$100, X
  
;   JSR compress_check

;   CPX #224   ; Offset to first tile in final row
;   BNE Loop2

;   Loop3:
;   JSR SkipRow
;   LDA BackgroundData+$200, X
  
;   JSR compress_check

;   CPX #224   ; Offset to first tile in final row
;   BNE Loop3

;   Loop4:
;   JSR SkipRow
;   LDA BackgroundData+$300, X
  
;   JSR compress_check

;   CPX #$A0   ; Offset to first tile in final row
;   BNE Loop4


DecompressBG:
  LDX #$00
@init2:
  LDA #0
  STA bit_loop
  STA top_half, X
  LDA #1
  STA bottom_half, X
  
  INX
  CPX #32
  BNE @init2

  LDA PPUSTATUS      ; reset PPU latch

  LDA #$20           ; nametable $2000
  STA PPUADDR
  LDA #$00
  STA PPUADDR

  JSR decompress



@attributes:
  ; finally, attribute table. These addresses don't match the actual characters
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$c2
	STA PPUADDR
	LDA #%01000000
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$e0
	STA PPUADDR
	LDA #%00001100
	STA PPUDATA

  ; --- Row 1 & 2 Attributes ---
  ; This row handles the split between Row 1 and Row 2 metatiles
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$C2
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$C4
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$C6
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$C9
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$CA
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$CB
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$CC
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$CD
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$CE
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  ; --- Row 3 & 4 Attributes ---
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D1
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D2
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D3
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D4
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D5
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D6
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D9
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$DA
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$DB
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$DC
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$DD
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$DE
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  ; --- Row 5 & 6 Attributes ---
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E1
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E2
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E3
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E4
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E5
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E6
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E9
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$EA
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$EB
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$EC
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$ED
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$EE
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  ; --- Final Row Cleanup ---
  ; This colors the bottom of the very last row
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$F1
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$F3
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$F5
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10000000  ; enable NMI, background uses pattern table $0000
  STA PPUCTRL
  LDA #%00011110  ; enable background + sprites
  STA PPUMASK

forever:
  JMP forever
.endproc

.proc SkipRow
  LDA MXindex
  CMP #$04
  BNE @exit_check

  LDA #0
  STA MXindex

  TXA
  CLC
  ADC #32
  TAX

  @exit_check:
  RTS
.endproc

.proc compress_check
  STA ID_Block, Y
  TXA
  PHA
  INY

  CPY #$04
  BNE @continue

  JSR compress
  LDY #$00

  @continue:
  PLA
  TAX

  INX
  INX

  RTS
.endproc


.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "RODATA"
palettes:
  .byte $22, $0f, $16, $27
  .byte $22, $0f, $2b, $3c
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00

  .byte $22, $0f, $16, $27
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00

BackgroundData:
	.byte $55,$55,$55,$55
  .byte $40,$00,$00,$01
  .byte $48,$C8,$C8,$C1
  .byte $40,$00,$00,$01
	.byte $4C,$8C,$8C,$81
  .byte $40,$00,$00,$01
  .byte $48,$C8,$C8,$C1
  .byte $40,$00,$00,$01
	.byte $4C,$8C,$8C,$81
  .byte $40,$00,$00,$01
  .byte $48,$C8,$C8,$C1
  .byte $40,$00,$00,$01
	.byte $4C,$8C,$8C,$81
  .byte $40,$00,$00,$01
	.byte $55,$55,$55,$55

.export BackgroundData

.segment "CHR"
.incbin "tiles.chr"