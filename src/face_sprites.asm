.segment  "ZEROPAGE"
.importzp sprite_x, sprite_y, tile_bit_mask, flip_state, sprite_tile_array
.importzp index_sprite, temp1, temp2

.segment "CODE"
.import draw_2x2

.export idle, rear, flipped_rear, yawn, happy, lenguetazo, right_1, right_2

.proc rear
  JSR set_palette
  LDX #$00

  LDA #$3b ; Tile top left
  STA sprite_tile_array, X
  INX

  LDA #$3c ; Tile top right
  STA sprite_tile_array, X
  INX

  LDA #$4b ; Tile bottom left
  STA sprite_tile_array, X
  INX

  LDA #$4c ; Tile bottom right
  STA sprite_tile_array, X
  INX

  JSR draw_2x2
  RTS
.endproc

.proc flipped_rear
  JSR set_palette
  LDX #$00

  LDA #$5b ; Tile top left
  STA sprite_tile_array, X
  INX

  LDA #$5c ; Tile top right
  STA sprite_tile_array, X
  INX

  LDA #$6b ; Tile bottom left
  STA sprite_tile_array, X
  INX

  LDA #$6c ; Tile bottom right
  STA sprite_tile_array, X
  INX

  JSR draw_2x2
  RTS
.endproc

.proc yawn
  JSR set_palette
  LDX #$00

  LDA #$37 ; Tile top left
  STA sprite_tile_array, X
  INX

  LDA #$38 ; Tile top right
  STA sprite_tile_array, X
  INX

  LDA #$45 ; Tile bottom left
  STA sprite_tile_array, X
  INX

  LDA #$46 ; Tile bottom right
  STA sprite_tile_array, X
  INX

  JSR draw_2x2
  RTS
.endproc

.proc happy
  JSR set_palette
  LDX #$00

  LDA #$15 ; Tile top left
  STA sprite_tile_array, X
  INX

  LDA #$16 ; Tile top right
  STA sprite_tile_array, X
  INX

  LDA #$17 ; Tile bottom left
  STA sprite_tile_array, X
  INX

  LDA #$18 ; Tile bottom right
  STA sprite_tile_array, X
  INX

  JSR draw_2x2
  RTS
.endproc

.proc lenguetazo
  JSR set_palette
  LDX #$00

  LDA #$19 ; Tile top left
  STA sprite_tile_array, X
  INX

  LDA #$1a ; Tile top right
  STA sprite_tile_array, X
  INX

  LDA #$1b ; Tile bottom left
  STA sprite_tile_array, X
  INX

  LDA #$1c ; Tile bottom right
  STA sprite_tile_array, X
  INX

  JSR draw_2x2
  RTS
.endproc

.proc right_1
  JSR set_palette
  LDX #$00

  LDA #$1d ; Tile top left
  STA sprite_tile_array, X
  INX

  LDA #$1e ; Tile top right
  STA sprite_tile_array, X
  INX

  LDA #$2d ; Tile bottom left
  STA sprite_tile_array, X
  INX

  LDA #$2e ; Tile bottom right
  STA sprite_tile_array, X
  INX

  JSR draw_2x2
  RTS
.endproc

.proc right_2
  JSR set_palette
  LDX #$00

  LDA #$3d ; Tile top left
  STA sprite_tile_array, X
  INX

  LDA #$3e ; Tile top right
  STA sprite_tile_array, X
  INX

  LDA #$4d ; Tile bottom left
  STA sprite_tile_array, X
  INX

  LDA #$4e ; Tile bottom right
  STA sprite_tile_array, X
  INX

  JSR draw_2x2
  RTS
.endproc

.proc idle
  JSR set_palette
  LDX #$00

  LDA #$37 ; Tile top left
  STA sprite_tile_array, X
  INX

  LDA #$38 ; Tile top right
  STA sprite_tile_array, X
  INX

  LDA #$47 ; Tile bottom left
  STA sprite_tile_array, X
  INX

  LDA #$48 ; Tile bottom right
  STA sprite_tile_array, X
  INX

  JSR draw_2x2
  RTS
.endproc

.proc set_palette
  LDA #$01
  STA tile_bit_mask

  RTS
.endproc