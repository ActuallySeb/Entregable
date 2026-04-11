.include "constants.inc"
.import BackgroundData

.segment "ZEROPAGE"
Collision_tiles:                .res 2

.importzp MXindex, MYindex, index, sprite_x, sprite_y, pads

.segment "CODE"
.proc position_to_Mindex
  LDA sprite_x

  LSR
  LSR
  LSR
  LSR

  STA MXindex

  LDA sprite_y

  LSR
  LSR
  LSR
  LSR

  STA MYindex

  JSR get_collision_tile

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
    JMP @exit

  @left:
    DEC MXindex
    JMP @exit
  
  @up:
    DEC MYindex
    JMP @exit
  
  @down:
    INC MYindex
    JMP @exit

  @exit:
  RTS
.endproc