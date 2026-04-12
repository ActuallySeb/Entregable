.include "constants.inc"

.segment "ZEROPAGE"
.importzp lives

.segment "CODE"
.export draw_lives_bg

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