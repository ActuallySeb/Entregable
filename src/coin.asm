.segment  "ZEROPAGE"
.importzp tile_bit_mask, sprite_tile_array
.importzp sprite_x, coin_x, sprite_y, coin_y

.segment "CODE"
.import draw_2x2
.export draw_coin

.proc star_coin
  JSR set_palette
  LDX #$00

  LDA #$06 ; Tile top left
  STA sprite_tile_array, X
  INX

  LDA #$07 ; Tile top right
  STA sprite_tile_array, X
  INX

  LDA #$08 ; Tile bottom left
  STA sprite_tile_array, X
  INX

  LDA #$09 ; Tile bottom right
  STA sprite_tile_array, X
  INX

  JSR draw_2x2
  RTS
.endproc

.proc set_palette
  LDA #$00
  STA tile_bit_mask

  RTS
.endproc

.proc draw_coin
  LDA coin_x
  STA sprite_x

  LDA  coin_y
  STA sprite_y

  JSR star_coin

  RTS
.endproc