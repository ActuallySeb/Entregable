.include "constants.inc"
.import BackgroundData

.segment "ZEROPAGE"
; MiXb:                .res 1
; MYb:                 .res 1

.importzp MXindex, MYindex, index, x_sprite, y_sprite, pads

.segment "CODE"
.proc position_to_Mindex
  LDA x_sprite

  LSR
  LSR
  LSR
  LSR

  STA MXindex

  LDA y_sprite

  LSR
  LSR
  LSR
  LSR

  STA MYindex

  LDA MYindex
  ASL
  ASL
  STA index

  LDA MXindex
  LSR
  CLC
  ADC index

  STA index

  RTS
.endproc

.proc get_collision_tile
  LDA pads
  AND BTN_RIGHT
  BEQ @right

  AND BTN_LEFT
  BEQ @left

  AND BTN_UP
  BEQ @up

  AND BTN_DOWN
  BEQ @down

  @right:
    INC MXindex
  @left:
    DEC MXindex
  @up:
    DEC MYindex
  @down:
    INC MYindex

  @exit:
  RTS
.endproc