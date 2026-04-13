.include "constants.inc"

.segment "ZEROPAGE"
.importzp player_x, player_y, enemy_x, enemy_y, player_prev_x, player_prev_y, coin_x, coin_y

.segment "CODE"
.export resolve_player_enemy_bodyblock, enemy_overlaps_player, player_overlaps_coin

.proc player_overlaps_coin
  LDA player_x
  CLC
  ADC #15
  CMP coin_x
  BCC @no

  LDA coin_x
  CLC
  ADC #15
  CMP player_x
  BCC @no

  LDA player_y
  CLC
  ADC #15
  CMP coin_y
  BCC @no

  LDA coin_y
  CLC
  ADC #15
  CMP player_y
  BCC @no

  LDA #1
  RTS

@no:
  LDA #0
  RTS

  RTS
.endproc

.proc enemy_overlaps_player
  LDA player_x
  CLC
  ADC #15
  CMP enemy_x
  BCC @no

  LDA enemy_x
  CLC
  ADC #15
  CMP player_x
  BCC @no

  LDA player_y
  CLC
  ADC #15
  CMP enemy_y
  BCC @no

  LDA enemy_y
  CLC
  ADC #15
  CMP player_y
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

  ; LDA player_prev_x
  ; STA player_x
  ; LDA player_prev_y
  ; STA player_y

@done:
  RTS
.endproc