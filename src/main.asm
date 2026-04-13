.include "constants.inc"
.include "header.inc"

.segment "ZEROPAGE"
; -- Compression --
Y_temp:             .res 1

; --Decompression --
top_half:           .res 32
bottom_half:        .res 32
MXindex:            .res 1
MYindex:            .res 1
index:              .res 1
sleep:              .res 1

; -- Sprites --
player_x:           .res 1
player_y:           .res 1

coin_x:             .res 1
coin_y:             .res 1

sprite_x:           .res 1
sprite_y:           .res 1

enemy_x:            .res 1
enemy_y:            .res 1

player_prev_x:      .res 1
player_prev_y:      .res 1

lives:              .res 1
damage_cooldown:    .res 1
game_over_drawn:    .res 1

tile_bit_mask:                     .res 1  ; Stores the bitmak of the current sprite being drawn
flip_state:                        .res 1  ; Stores flip status (0 = normal, 1 = mirrored)
sprite_tile_array:                 .res 4

index_sprite:                      .res 1
temp1:                             .res 1
temp2:                             .res 1

sprite_animation_state:            .res 1
frame_counter:                     .res 1

pads:                              .res 1
prev_pads:                         .res 1

coin_counter:                      .res 1

.exportzp Y_temp, MXindex, MYindex, index, top_half, bottom_half, sprite_x, sprite_y
.exportzp flip_state, frame_counter, index_sprite, pads, prev_pads, sprite_animation_state, sprite_tile_array
.exportzp temp1, temp2, tile_bit_mask, enemy_x, enemy_y, player_x, player_y, coin_x, coin_y
.exportzp player_prev_x, player_prev_y, lives, damage_cooldown, coin_counter, game_over_drawn

.segment "CODE"
.import decompress, set_attr_table, update_animation, read_controllers, update_player
.import update_enemy, draw_enemy, draw_player, draw_coin, randomize_coin
.import resolve_player_enemy_bodyblock, enemy_overlaps_player
.import draw_lives_bg
.import handle_player_damage
.import handle_game_over

.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  JSR update_animation
  JSR read_controllers
  JSR draw_lives_bg
  JSR handle_game_over

  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
	LDA #$00
	STA $2005
	STA $2005

  LDA #0
  STA sleep

  LDA damage_cooldown
  BEQ @no_damage_tick
  DEC damage_cooldown
@no_damage_tick:

  LDA lives
  BEQ @no_pause

  LDA prev_pads
  AND #BTN_START
  BNE @no_pause

  LDA pads
  AND #BTN_START
  BEQ @no_pause

  LDA Pause
  EOR #1
  STA Pause

  @no_pause:
  RTI
.endproc

.import reset_handler

.export main
.proc main
  ; wait for first vblank
  vblankwait1:
  BIT PPUSTATUS
  BPL vblankwait1
  
  ; write a palette
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR
load_palettes:
  LDA palettes,X
  STA PPUDATA
  INX
  CPX #$20
  BNE load_palettes

  LDX #$00
  LDA #0
@init:
  STA sprite_x
  STA sprite_y
  STA enemy_x
  STA enemy_y
  STA frame_counter
  STA sprite_animation_state
  STA flip_state
  STA temp1
  STA temp2
  STA pads
  STA coin_counter
  STA Pause
  STA lives
  STA damage_cooldown
  STA game_over_drawn

  STA top_half, X
  STA bottom_half, X

  INX
  CPX #32
  BNE @init

  LDA #$30
  STA player_x
  LDA #$30
  STA player_y

  LDA #$5f
  STA coin_x
  LDA #$70
  STA coin_y

  LDA #$40
  STA enemy_x
  LDA #$40
  STA enemy_y

  LDA #3
  STA lives

DecompressBG:
  LDX #$00
@init2:
  LDA #0
  STA top_half, X
  LDA #1
  STA bottom_half, X
  
  INX
  CPX #32
  BNE @init2

  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR

  JSR decompress
  JSR set_attr_table

vblankwait:
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10000000
  STA PPUCTRL
  LDA #%00011110
  STA PPUMASK

  JSR randomize_coin
main_loop:
  LDX #0
  LDY #0
  LDA #0
  STA temp1
  STA temp2

  JSR update_player

  JSR draw_coin


  JSR handle_player_damage
  JSR resolve_player_enemy_bodyblock
  JSR update_enemy
  JSR handle_player_damage


  JSR draw_enemy

sleep_loop:
  LDA sleep
  BNE sleep_loop

  LDA #1
  STA sleep

  @paused:
  LDA Pause
  BNE @paused

  JMP main_loop
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "RODATA"
palettes:
  .byte $22, $0f, $16, $27
  .byte $22, $0f, $16, $27
  .byte $22, $0f, $16, $27
  .byte $22, $0f, $02, $12

  .byte $22, $0f, $2b, $3c
  .byte $22, $06, $17, $27
  .byte $22, $0f, $16, $27
  .byte $22, $0f, $16, $27

BackgroundData:
	.byte $00,$00,$00,$00
  .byte $00,$00,$00,$00
  .byte $55,$55,$55,$55
  .byte $40,$0E,$A0,$01
	.byte $40,$08,$00,$01
  .byte $42,$00,$00,$81
  .byte $42,$00,$20,$81
  .byte $42,$08,$20,$01
	.byte $40,$08,$20,$01
  .byte $40,$08,$20,$81
  .byte $42,$08,$00,$81
  .byte $42,$00,$00,$81
  .byte $40,$00,$20,$01
  .byte $40,$0A,$B0,$01
	.byte $55,$55,$55,$55

.export BackgroundData

.segment "CHR"
.incbin "tiles.chr"