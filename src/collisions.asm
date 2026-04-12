.include "constants.inc"
.import BackgroundData

.segment "ZEROPAGE"
; Collision_tiles:                .res 2

; .exportzp Collision_tiles
.importzp MXindex, MYindex, index, sprite_x, sprite_y, pads, temp1

.segment "CODE"
.export position_to_Mindex, get_collision_tile

.proc position_to_Mindex
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
    INC MXindex
    JSR get_tile

    INC MYindex
    JSR get_tile

    DEC MXindex
    DEC MYindex

    JMP @exit

  @left:
    JSR get_tile

    INC MYindex
    JSR get_tile

    DEC MYindex

    JMP @exit

  @up:
    JSR get_tile

    INC MXindex
    JSR get_tile

    DEC MXindex

    JMP @exit

  @down:
    INC MYindex
    JSR get_tile

    INC MXindex
    JSR get_tile

    DEC MYindex
    DEC MXindex

    JMP @exit

  @exit:
  LDA #0
  STA temp1

  RTS
.endproc

.proc get_tile
  LDA MYindex
  STA $0310
  ASL
  ASL
  STA index

  LDA MXindex
  STA $0311
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
  ; @reduce_below_4:
  ; CMP #4
  ; BCC @retrieve
  
  ; SEC
  ; SBC #4
  ; JMP @reduce_below_4

  @retrieve:
  TAX
  STA $0315
  LDA BackgroundData, Y
  STA $0305

  @shift_left:
  CPX #0
  BEQ @mask

  ASL
  ASL

  DEX
  JMP @shift_left
  
  @mask:
  AND #%11000000
  STA $0306

  LSR
  LSR
  LSR
  LSR
  LSR
  LSR

  STA $0307

  LDY temp1
  STA Collision_tiles, Y
  STA $0304
  INY

  PLA
  TAX
  PLA
  TAY

  RTS
.endproc