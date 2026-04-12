.include "constants.inc"

.segment "ZEROPAGE"
.importzp sprite_x, sprite_y, enemy_x, enemy_y, player_prev_x, player_prev_y

.segment "CODE"
.export resolve_player_enemy_bodyblock, enemy_overlaps_player

.proc enemy_overlaps_player
  LDA sprite_x
  CLC
  ADC #15
  CMP enemy_x
  BCC @no

  LDA enemy_x
  CLC
  ADC #15
  CMP sprite_x
  BCC @no

  LDA sprite_y
  CLC
  ADC #15
  CMP enemy_y
  BCC @no

  LDA enemy_y
  CLC
  ADC #15
  CMP sprite_y
  BCC @no

  LDA #1
  RTS

@no:
  LDA #0
  RTS
.endproc

.proc resolve_player_enemy_bodyblock
  JSR enemy_overlaps_player
  BEQ @done

  LDA player_prev_x
  STA sprite_x
  LDA player_prev_y
  STA sprite_y

@done:
  RTS
.endproc