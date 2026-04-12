.include "constants.inc"

.segment "ZEROPAGE"
.importzp lives, damage_cooldown

.segment "CODE"
.import enemy_overlaps_player
.export handle_player_damage

.proc handle_player_damage
  LDA damage_cooldown
  BNE @done

  JSR enemy_overlaps_player
  BEQ @done

  LDA lives
  BEQ @done

  DEC lives
  LDA #60
  STA damage_cooldown

@done:
  RTS
.endproc