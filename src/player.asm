.include "constants.inc"


.segment "ZEROPAGE"
.importzp sprite_x, sprite_y, pads

.segment "CODE"
.export move_sprite
.proc update_player

  JSR move_sprite
  RTS
.endproc

.proc move_sprite
  LDA pads
  AND #BTN_RIGHT
  BNE @move_right

  LDA pads
  AND #BTN_LEFT
  BNE @move_left

  LDA pads
  AND #BTN_UP
  BNE @move_up

  LDA pads
  AND #BTN_DOWN
  BNE @move_down

  JMP @exit_movement

  @move_right:
    JSR move_right
    JMP @exit_movement

  @move_left:
    JSR move_left
    JMP @exit_movement

  @move_up:
    JSR move_up
    JMP @exit_movement

  @move_down:
    JSR move_down

  @exit_movement:
  RTS
.endproc

.proc move_left
  LDA sprite_x
  SEC
  SBC #2
  STA sprite_x

  RTS
.endproc

.proc move_right
  LDA sprite_x
  CLC
  ADC #2
  STA sprite_x

  RTS
.endproc

.proc move_up
  LDA sprite_y
  SEC
  SBC #2
  STA sprite_y

  RTS
.endproc

.proc move_down
  LDA sprite_y
  CLC
  ADC #2
  STA sprite_y

  RTS
.endproc