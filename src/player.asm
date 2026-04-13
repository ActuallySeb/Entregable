.include "constants.inc"

.segment "ZEROPAGE"
.importzp player_prev_x, player_prev_y

.importzp sprite_x, sprite_y, pads, flip_state, Collision_tiles, player_x, player_y, coin_counter

.segment "CODE"
.import walk_cycle, rear_cycle, forward_cycle, idle, check_player_BG_collisions
.import BG_collision_damage, randomize_coin, player_overlaps_coin
.export update_player, move_sprite


.proc update_player
  LDA player_x
  STA sprite_x
  STA player_prev_x

  LDA player_y
  STA sprite_y
  STA player_prev_y

  LDX #0
  JSR move_sprite

  JSR player_overlaps_coin
  BEQ @check_BG

  LDA sprite_x
  STA player_x

  LDA sprite_y
  STA player_y
  
  JSR randomize_coin
  INC coin_counter

  LDA player_x
  STA sprite_x

  LDA player_y
  STA sprite_y

  @check_BG:
  JSR check_player_BG_collisions

  LDX #0
  @check_tiles:
    LDA Collision_tiles, X
    INX
    CMP #0
    BNE @restore_sprite

    CPX #2
    BNE @check_tiles

    JMP @exit_update

  @restore_sprite:
    LDA player_prev_x
    STA sprite_x
    LDA player_prev_y
    STA sprite_y

    LDA Collision_tiles, X
    CMP #1
    BEQ @exit_update

    JSR BG_collision_damage

  @exit_update:
    LDA sprite_x
    STA player_x

    LDA sprite_y
    STA player_y

    JSR draw_player

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