.include "constants.inc"
.import BackgroundData

.segment "ZEROPAGE"
enemy_prev_x:             .res 1
enemy_prev_y:             .res 1
enemy_mt_x:               .res 1
enemy_mt_y:               .res 1
enemy_index:              .res 1
enemy_temp1:              .res 1
EnemyCollision_tiles:     .res 2

.importzp enemy_x, enemy_y, sprite_x, sprite_y, frame_counter


.segment "CODE"
.import enemy_overlaps_player
.export update_enemy, draw_enemy

.proc update_enemy
  LDA enemy_x
  STA enemy_prev_x
  LDA enemy_y
  STA enemy_prev_y

  LDA frame_counter
  AND #$01
  BEQ @x_first

@y_first:
  JSR move_enemy_y
  JSR position_to_enemy_Mindex
  LDX #0
@check_y_tiles:
  LDA EnemyCollision_tiles, X
  INX
  CMP #0
  BNE @restore_y
  CPX #2
  BNE @check_y_tiles
  JMP @try_x_after_y

@restore_y:
  LDA enemy_prev_y
  STA enemy_y

@try_x_after_y:
  LDA enemy_x
  STA enemy_prev_x
  JSR move_enemy_x
  JSR position_to_enemy_Mindex
  LDX #0
@check_x_tiles_after_y:
  LDA EnemyCollision_tiles, X
  INX
  CMP #0
  BNE @restore_x_after_y
  CPX #2
  BNE @check_x_tiles_after_y
  JMP @check_bodyblock

@restore_x_after_y:
  LDA enemy_prev_x
  STA enemy_x
  JMP @check_bodyblock

@x_first:
  JSR move_enemy_x
  JSR position_to_enemy_Mindex
  LDX #0
@check_x_tiles:
  LDA EnemyCollision_tiles, X
  INX
  CMP #0
  BNE @restore_x
  CPX #2
  BNE @check_x_tiles
  JMP @try_y_after_x

@restore_x:
  LDA enemy_prev_x
  STA enemy_x

@try_y_after_x:
  LDA enemy_y
  STA enemy_prev_y
  JSR move_enemy_y
  JSR position_to_enemy_Mindex
  LDX #0
@check_y_tiles_after_x:
  LDA EnemyCollision_tiles, X
  INX
  CMP #0
  BNE @restore_y_after_x
  CPX #2
  BNE @check_y_tiles_after_x
  JMP @check_bodyblock

@restore_y_after_x:
  LDA enemy_prev_y
  STA enemy_y

@check_bodyblock:
  JSR enemy_overlaps_player
  BEQ @done

  LDA enemy_prev_x
  STA enemy_x
  LDA enemy_prev_y
  STA enemy_y

@done:
  RTS
.endproc

.proc move_enemy_x
  LDA enemy_x
  CMP sprite_x
  BEQ @exit_move_x
  BCC @move_right

@move_left:
  DEC enemy_x
  RTS

@move_right:
  INC enemy_x

@exit_move_x:
  RTS
.endproc

.proc move_enemy_y
  LDA enemy_y
  CMP sprite_y
  BEQ @exit_move_y
  BCC @move_down

@move_up:
  DEC enemy_y
  RTS

@move_down:
  INC enemy_y

@exit_move_y:
  RTS
.endproc

.proc position_to_enemy_Mindex
  LDA enemy_x
  CLC
  ADC #4
  LSR
  LSR
  LSR
  LSR
  STA enemy_mt_x

  LDA enemy_y
  CLC
  ADC #4
  LSR
  LSR
  LSR
  LSR
  STA enemy_mt_y

  JSR get_enemy_collision_tile

  RTS
.endproc

.proc get_enemy_collision_tile
  LDA #0
  STA enemy_temp1

  LDA enemy_x
  CMP enemy_prev_x
  BEQ @check_vertical
  BCC @left

@right:
  INC enemy_mt_x
  JSR get_enemy_tile

  INC enemy_mt_y
  JSR get_enemy_tile

  DEC enemy_mt_x
  DEC enemy_mt_y
  JMP @exit

@check_vertical:
  LDA enemy_y
  CMP enemy_prev_y
  BEQ @exit
  BCC @up

@down:
  INC enemy_mt_y
  JSR get_enemy_tile

  INC enemy_mt_x
  JSR get_enemy_tile

  DEC enemy_mt_y
  DEC enemy_mt_x
  JMP @exit

@left:
  JSR get_enemy_tile

  INC enemy_mt_y
  JSR get_enemy_tile

  DEC enemy_mt_y
  JMP @exit

@up:
  JSR get_enemy_tile

  INC enemy_mt_x
  JSR get_enemy_tile

  DEC enemy_mt_x

@exit:
  LDA #0
  STA enemy_temp1
  RTS
.endproc

.proc get_enemy_tile
  LDA enemy_mt_y
  ASL
  ASL
  STA enemy_index

  LDA enemy_mt_x
  LSR
  LSR
  CLC
  ADC enemy_index
  STA enemy_index

  TYA
  PHA
  TXA
  PHA

  LDY enemy_index
  LDA enemy_mt_x
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

  LDY enemy_temp1
  STA EnemyCollision_tiles, Y
  INC enemy_temp1

  PLA
  TAX
  PLA
  TAY

  RTS
.endproc

.proc draw_enemy
  LDX #$10

  LDA enemy_y
  STA $0200, X
  LDA #$31
  STA $0201, X
  LDA #$02
  STA $0202, X
  LDA enemy_x
  STA $0203, X

  INX
  INX
  INX
  INX

  LDA enemy_y
  STA $0200, X
  LDA #$32
  STA $0201, X
  LDA #$02
  STA $0202, X
  LDA enemy_x
  CLC
  ADC #8
  STA $0203, X

  INX
  INX
  INX
  INX

  LDA enemy_y
  CLC
  ADC #8
  STA $0200, X
  LDA #$41
  STA $0201, X
  LDA #$02
  STA $0202, X
  LDA enemy_x
  STA $0203, X

  INX
  INX
  INX
  INX

  LDA enemy_y
  CLC
  ADC #8
  STA $0200, X
  LDA #$42
  STA $0201, X
  LDA #$02
  STA $0202, X
  LDA enemy_x
  CLC
  ADC #8
  STA $0203, X

  RTS
.endproc