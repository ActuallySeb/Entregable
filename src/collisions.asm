.include "constants.inc"
.import BackgroundData

.segment "ZEROPAGE"
MiXb:                .res 1
MYb:                 .res 1

.importzp ID_Block, Y_temp, MXindex, MYindex, bit_loop, index, top_half, bottom_half, x_sprite, y_sprite

.segment "CODE"
.proc background_collision
  LDA x_sprite

  LSR
  LSR
  LSR
  LSR

  STA MiXb

  LDA y_sprite

  LSR
  LSR
  LSR
  LSR

  STA MYb

  LDA MYb
  ASL
  ASL

  CLC
  ADC MiXb
  LSR

  STA index

  RTS
.endproc