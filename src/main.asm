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

pads: .res 1
prev_pads: .res 1

.exportzp Y_temp, MXindex, MYindex, bit_loop, index, top_half, bottom_half, sprite_x, sprite_y
.exportzp flip_state, frame_counter, index_sprite, pads, prev_pads, sprite_animation_state, sprite_tile_array
.exportzp temp1, temp2, tile_bit_mask

.segment "CODE"
.import decompress, read_controllers, walk_cycle, move_sprite, rear, yawn

.proc irq_handler
  RTI
.endproc

.proc nmi_handler

  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
	LDA #$00
	STA $2005
	STA $2005

  DEC sleep

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
  STA prev_pads

  STA bit_loop
  STA top_half, X
  STA bottom_half, X


  INX
  CPX #32
  BNE @init

  LDA #$cc
  STA sprite_x
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



@attributes:
  ; finally, attribute table. These addresses don't match the actual characters
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$c2
	STA PPUADDR
	LDA #%01000000
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$e0
	STA PPUADDR
	LDA #%00001100
	STA PPUDATA

  ; --- Row 1 & 2 Attributes ---
  ; This row handles the split between Row 1 and Row 2 metatiles
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$C2
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$C4
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$C6
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$C9
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$CA
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$CB
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$CC
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$CD
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$CE
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  ; --- Row 3 & 4 Attributes ---
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D1
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D2
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D3
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D4
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D5
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D6
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$D9
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$DA
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$DB
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$DC
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$DD
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$DE
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  ; --- Row 5 & 6 Attributes ---
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E1
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E2
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E3
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E4
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E5
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E6
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$E9
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$EA
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$EB
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$EC
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$ED
  STA PPUADDR
  LDA #%00010000
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$EE
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  ; --- Final Row Cleanup ---
  ; This colors the bottom of the very last row
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$F1
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$F3
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA

  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$F5
  STA PPUADDR
  LDA #%00000001
  STA PPUDATA



vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10000000  ; enable NMI, background uses pattern table $0000
  STA PPUCTRL
  LDA #%00011110  ; enable background + sprites
  STA PPUMASK

main_loop:
  JSR read_controllers
  JSR move_sprite

  ; LDX #0
  ; LDY #0
  ; JSR rear
  JSR yawn

sleep_loop:
  LDA sleep
  BNE sleep_loop

  INC sleep
  JMP main_loop
.endproc



.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "RODATA"
palettes:
  .byte $22, $0f, $16, $27
  .byte $22, $0f, $2b, $3c
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00

  .byte $22, $0f, $16, $27
  .byte $22, $05, $16, $27
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00

BackgroundData:
	.byte $55,$55,$55,$55
  .byte $40,$00,$00,$01
  .byte $48,$C8,$C8,$C1
  .byte $40,$00,$00,$01
	.byte $4C,$8C,$8C,$81
  .byte $40,$00,$00,$01
  .byte $48,$C8,$C8,$C1
  .byte $40,$00,$00,$01
	.byte $4C,$8C,$8C,$81
  .byte $40,$00,$00,$01
  .byte $48,$C8,$C8,$C1
  .byte $40,$00,$00,$01
	.byte $4C,$8C,$8C,$81
  .byte $40,$00,$00,$01
	.byte $55,$55,$55,$55

.export BackgroundData

.segment "CHR"
.incbin "tiles.chr"