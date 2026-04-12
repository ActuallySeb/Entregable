.include "constants.inc"
.include "header.inc"

.segment "ZEROPAGE"
; -- Compression --
; ID_Block:           .res 4
Y_temp:             .res 1


; --Decompression --
top_half:           .res 32
bottom_half:        .res 32
MXindex:            .res 1
MYindex:            .res 1
bit_loop:           .res 1
index:              .res 1
sleep:              .res 1

; -- Sprites --
sprite_x:           .res 1
sprite_x_prev:      .res 1
sprite_y:           .res 1
sprite_y_prev:      .res 1

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

.exportzp Y_temp, MXindex, MYindex, bit_loop, index, top_half, bottom_half, sprite_x, sprite_y
.exportzp flip_state, frame_counter, index_sprite, pads, prev_pads, sprite_animation_state, sprite_tile_array
.exportzp temp1, temp2, tile_bit_mask

.segment "CODE"
.import decompress, set_attr_table, update_animation, read_controllers, update_player, move_sprite, draw_player

.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  JSR update_animation
  JSR read_controllers

  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
	LDA #$00
	STA $2005
	STA $2005

  LDA #0
  STA sleep

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
  LDA 0
@init:
  STA sprite_x
  STA sprite_y
  STA frame_counter
  STA sprite_animation_state
  STA flip_state
  STA temp1
  STA temp2
  STA pads
  STA Pause

  STA bit_loop
  STA top_half, X
  STA bottom_half, X


  INX
  CPX #32
  BNE @init

  LDA #$D0
  STA sprite_x
  LDA #$c6
  STA sprite_y
DecompressBG:
  LDX #$00
@init2:
  LDA #0
  STA bit_loop
  STA top_half, X
  LDA #1
  STA bottom_half, X
  
  INX
  CPX #32
  BNE @init2

  LDA PPUSTATUS      ; reset PPU latch

  LDA #$20           ; nametable $2000
  STA PPUADDR
  LDA #$00
  STA PPUADDR

  JSR decompress

  JSR set_attr_table

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10000000  ; enable NMI, background uses pattern table $0000
  STA PPUCTRL
  LDA #%00011110  ; enable background + sprites
  STA PPUMASK

main_loop:
  LDX #0
  LDY #0
  LDA 0
  STA temp1
  STA temp2

  JSR update_player

  JSR draw_player

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
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00

  .byte $22, $0f, $16, $27
  .byte $22, $05, $16, $27
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00

BackgroundData:
	.byte $AA,$AA,$AA,$AA
  .byte $AA,$AA,$AA,$AA
  .byte $55,$55,$55,$55 ; HERE
  .byte $40,$0A,$A0,$01 ; -
	.byte $40,$08,$00,$01 ; --
  .byte $42,$00,$00,$81 ; ---
  .byte $42,$00,$20,$81 ; ----
  .byte $42,$08,$20,$01 ; -----
	.byte $40,$08,$20,$01 ; ------ 
  .byte $40,$08,$20,$81 ; -----
  .byte $42,$08,$00,$81 ; ----
  .byte $42,$00,$00,$81 ; ---
  .byte $40,$00,$20,$01 ; --
  .byte $40,$0A,$A0,$01 ; -
	.byte $55,$55,$55,$55 ; HERE

.export BackgroundData

.segment "CHR"
.incbin "tiles.chr"