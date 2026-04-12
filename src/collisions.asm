.include "constants.inc"
.import BackgroundData

.segment "ZEROPAGE"
Collision_tiles:                .res 4

.exportzp Collision_tiles
.importzp MXindex, MYindex, index, sprite_x, sprite_y, pads, temp1

.segment "CODE"
.export check_BG_collisions, get_collision_tile

.proc check_BG_collisions
  LDA sprite_x

  LSR
  LSR
  LSR
  LSR

  STA MXindex ; used as metatile per row

  LDA sprite_y

  LSR
  LSR
  LSR
  LSR

  STA MYindex

  JSR get_collision_tile

  RTS
.endproc

.proc get_collision_tile
  LDA #0
  STA temp1

  LDA pads
  AND #BTN_RIGHT
  BNE @right

  LDA pads
  AND #BTN_LEFT
  BNE @left

  LDA pads
  AND #BTN_UP
  BNE @up

  LDA pads
  AND #BTN_DOWN
  BNE @down

  JMP @exit

  @right:
    JSR INC_MXindex

    JSR get_tile

    INC MYindex
    JSR get_tile

    JMP @exit

  @left:
    JSR get_tile

    INC MYindex
    JSR get_tile

    JMP @exit

  @up:
    JSR get_tile

    JSR INC_MXindex

    JSR get_tile

    JMP @exit

  @down:
    INC MYindex
    JSR get_tile

    INC MXindex
    JSR over_underflow_MXindex
    JSR get_tile

    JMP @exit

  @exit:
  LDA #0
  STA temp1

  RTS
.endproc

.proc get_tile
  LDA MYindex
  ASL
  ASL
  STA index

  LDA MXindex
  LSR
  LSR
  CLC
  ADC index

  STA index

  TYA
  PHA
  TXA
  PHA

  LDY index
  LDA MXindex
  AND #%00000011

  @retrieve:
  TAX
  LDA BackgroundData, Y

  @shift_left:
  CPX #0
  BEQ @mask

  ASL
  ASL

  DEX
  JMP @shift_left
  
  @mask:
  AND #%11000000

  LSR
  LSR
  LSR
  LSR
  LSR
  LSR

  LDY temp1
  STA Collision_tiles, Y
  INC temp1

  PLA
  TAX
  PLA
  TAY

  RTS
.endproc

.proc INC_MXindex
  INC MXindex
  JSR over_underflow_MXindex

  RTS
.endproc

.proc DEC_MXindex
  DEC MXindex
  JSR over_underflow_MXindex

  RTS
.endproc

.proc over_underflow_MXindex
  LDA MXindex
  CMP #$FF
  BEQ @underflow

  LDA MXindex
  CMP #16
  BEQ @overflow

  JMP @exit_over_under

  @overflow:
  LDA #0
  STA MXindex

  JMP @exit_over_under

  @underflow:
  LDA #15
  STA MXindex

  @exit_over_under:
  RTS
.endproc