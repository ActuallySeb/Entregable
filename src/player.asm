.include "constants.inc"


.segment "ZEROPAGE"
.importzp sprite_x, sprite_y, pads, flip_state

.segment "CODE"
.import walk_cycle, rear_cycle, forward_cycle, idle
.export move_sprite, draw_player


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

.proc draw_player
  LDA pads
  AND #(BTN_RIGHT | BTN_LEFT)
  BNE @draw_horizontal

  LDA pads
  AND #BTN_UP
  BNE @draw_up

  LDA pads
  AND #BTN_DOWN
  BNE @draw_down

  JSR  idle

  JMP @exit_draw

  @draw_horizontal:
    LDA pads
    AND #BTN_RIGHT
    BNE @draw_right

    @draw_left:
    LDA #1
    STA flip_state
    JMP @draw_inline

    @draw_right:
    LDA #0
    STA flip_state

    @draw_inline:
    JSR walk_cycle
    JMP @exit_draw

  @draw_up:
    JSR rear_cycle
    JMP @exit_draw

  @draw_down:
    JSR forward_cycle

  @exit_draw:
  RTS
.endproc