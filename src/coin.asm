.segment  "ZEROPAGE"
.importzp tile_bit_mask, sprite_tile_array, frame_counter
.importzp sprite_x, coin_x, sprite_y, coin_y, Collision_tiles

.segment "CODE"
.import draw_2x2, check_coin_BG_overlay
.export draw_coin, randomize_coin

.proc randomize_coin
  @randomize_x:
  LDA coin_x
  ASL
  BCC @no_xor_x
  EOR frame_counter
  @no_xor_x:
  STA coin_x

  JSR check_coin_BG_overlay
  LDX #0

  @check_x_boundaries:
  LDA Collision_tiles, X
  INX
  CMP #0
  BNE @randomize_x

  CPX #4
  BNE @check_x_boundaries

  @randomize_y:
  LDA coin_y
  ASL
  BCC @no_xor_y
  EOR frame_counter
  @no_xor_y:
  STA coin_y

  JSR check_coin_BG_overlay
  LDX #0

  @check_y_boundaries:
  LDA Collision_tiles, X
  INX
  CMP #0
  BNE @randomize_y

  CPX #4
  BNE @check_y_boundaries

  RTS
.endproc

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