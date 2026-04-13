.include "constants.inc"

.segment "ZEROPAGE"
.importzp lives, game_over_drawn

.segment "CODE"
.export handle_game_over

.proc handle_game_over
  LDA lives
  BNE @done

  LDA #1
  STA Pause

  LDA game_over_drawn
  BNE @done

  LDA PPUSTATUS
  LDA #$21
  STA PPUADDR
  LDA #$4B
  STA PPUADDR

  LDA #$55
  STA PPUDATA
  LDA #$56
  STA PPUDATA
  LDA #$57
  STA PPUDATA
  LDA #$54
  STA PPUDATA
  LDA #$00
  STA PPUDATA
  LDA #$52
  STA PPUDATA
  LDA #$58
  STA PPUDATA
  LDA #$54
  STA PPUDATA
  LDA #$53
  STA PPUDATA

  LDA #1
  STA game_over_drawn

@done:
  RTS
.endproc