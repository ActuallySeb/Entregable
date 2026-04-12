.include "constants.inc"
.import BackgroundData

.segment "ZEROPAGE"
masked_bit:            .res 1
X_temp:                .res 1
; Y_temp:                .res 1

.importzp Y_temp, MXindex, MYindex, bit_loop, index, top_half, bottom_half

.segment "CODE"
.export decompress, set_attr_table

.proc decompress
  LDX #0          ; compressed index
  LDA #0
  STA index
  STA X_temp
  STA MXindex

NextByte:
  LDA BackgroundData,X
  STA masked_bit
  LDY #4

ExtractLoop:
  LDA masked_bit

  LSR
  LSR
  LSR
  LSR
  LSR
  LSR        ; move AA → bits 1-0
  
  AND #%00000011
  JSR compare

  ASL masked_bit
  ASL masked_bit   ; remove AA from byte

  DEY
  BNE ExtractLoop

  INC MXindex
  LDA MXindex
  CMP #4
  BNE SkipDraw

  LDA #0
  STA MXindex
  JSR draw_decompressed

  LDA #0
  STA index

  SkipDraw:
  STX X_temp
  INX
  CPX #60         ; number of compressed bytes
  BNE NextByte

  RTS
.endproc

.proc compare
  STX X_temp
  LDX index

  CMP #0
  BEQ @C_option1
  
  CMP #1
  BEQ @C_option2

  CMP #2
  BEQ @C_option3

  CMP #3
  BEQ @C_option4

  @C_option1:
  JSR push_blank
  JMP @exit_compare

  @C_option2:
  JSR push_brick
  JMP @exit_compare

  @C_option3:
  JSR push_question
  JMP @exit_compare

  @C_option4:
  JSR push_star

  @exit_compare:
  STX index
  LDX X_temp

  RTS
.endproc

.proc draw_decompressed
  LDY #0
  STY index

  @draw_top:
  LDA top_half, Y
  STA PPUDATA
  INY
  CPY #32
  BNE @draw_top

  LDY #0

  @draw_bottom:
  LDA bottom_half, Y
  STA PPUDATA
  INY
  CPY #32
  BNE @draw_bottom

  INC MYindex

  RTS
.endproc

.proc push_blank
  LDA #0
  STA top_half, X
  STA bottom_half, X

  INX

  STA top_half, X
  STA bottom_half, X

  INX

  RTS
.endproc

.proc push_brick
  LDA #5
  STA top_half, X
  STA bottom_half, X

  INX

  STA top_half, X
  STA bottom_half, X

  INX

  RTS
.endproc

.proc push_question
  LDA #1
  STA top_half, X
  LDA #3
  STA bottom_half, X

  INX

  LDA #2
  STA top_half, X
  LDA #4
  STA bottom_half, X

  INX

  RTS
.endproc

.proc push_star
  LDA #6
  STA top_half, X
  LDA #8
  STA bottom_half, X

  INX

  LDA #7
  STA top_half, X
  LDA #9
  STA bottom_half, X

  INX

  RTS
.endproc

.proc set_attr_table
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
  LDA #%00010000
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
  LDA #%00010000
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
  LDA #%00010000
  STA PPUDATA

  ; --- Row 3 & 4 Attributes ---
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D1
  STA PPUADDR
  LDA #%00010000
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
  LDA #%00010000
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
  LDA #%00010000
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
  LDA #%00010000
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
  LDA #%00010000
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
  LDA #%00010000
  STA PPUDATA

  ; --- Row 5 & 6 Attributes ---
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E1
  STA PPUADDR
  LDA #%00010000
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
  LDA #%00010000
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
  LDA #%00010000
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
  LDA #%00010000
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
  LDA #%00010000
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
  LDA #%00010000
  STA PPUDATA

  ; --- Final Row Cleanup ---
  ; This colors the bottom of the very last row
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$F1
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$F3
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$F5
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  RTS
.endproc