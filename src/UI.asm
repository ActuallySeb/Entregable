.include "constants.inc"

.segment "ZEROPAGE"
.importzp lives, coin_counter
score_tens: .res 1
score_ones: .res 1

.segment "CODE"
.export draw_lives_bg, draw_score_bg

.proc draw_lives_bg
  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$7C
  STA PPUADDR

  LDA lives
  CLC
  ADC #$10
  STA PPUDATA

  LDA #$30
  STA PPUDATA

  RTS
.endproc

.proc draw_score_bg
  LDA coin_counter
  STA score_ones
  LDA #0
  STA score_tens

@subtract_10:
  LDA score_ones
  CMP #10
  BCC @digits_ready
  SEC
  SBC #10
  STA score_ones
  INC score_tens
  JMP @subtract_10

@digits_ready:
  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$62
  STA PPUADDR

  LDA #$50
  STA PPUDATA
  LDA #$51
  STA PPUDATA
  LDA #$52
  STA PPUDATA
  LDA #$53
  STA PPUDATA
  LDA #$54
  STA PPUDATA
  LDA #$00
  STA PPUDATA

  LDA score_tens
  JSR draw_digit_tile

  LDA score_ones
  JSR draw_digit_tile

  RTS
.endproc

.proc draw_digit_tile
  CMP #5
  BCC @digit_0_4

  SEC
  SBC #5
  CLC
  ADC #$20
  STA PPUDATA
  RTS

@digit_0_4:
  CLC
  ADC #$10
  STA PPUDATA
  RTS
.endproc