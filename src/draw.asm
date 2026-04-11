.include "constants.inc"

.segment "ZEROPAGE"
.importzp sprite_x, sprite_y, tile_bit_mask, flip_state, sprite_tile_array, index_sprite, temp1, temp2, frame_counter, sprite_animation_state

.segment "CODE"
.export update_animation, draw_2x2, draw_1x1, draw_2x1

.proc update_animation
  INC frame_counter
  LDA frame_counter
  CMP #CYCLE
  BNE @skip_reset1

    ; Toggle posture (0 <-> 1)
    LDA sprite_animation_state
    EOR #$01
    STA sprite_animation_state

    LDA #0
    STA frame_counter
  
  @skip_reset1:
  LDA frame_counter
  CMP #HALF_CYCLE
  BNE @skip_reset2

    ; Toggle posture (0 <-> 1)
    LDA sprite_animation_state
    EOR #$01
    STA sprite_animation_state
  
  @skip_reset2:
    RTS
.endproc

.proc draw_2x2
  LDY temp1  ;  Load Player on RegY

  LDX #$00   ;  Tile Array Index
 
  JSR draw_2x1
  JSR shift_down

  JSR draw_2x1
  JSR shift_up

  LDY temp2  ;  Restore Mem Offset

  RTS
.endproc

.proc draw_2x1
  LDA flip_state
  BNE @invert_tiles

  ;--------------------------------- Normal Row tiles
  
  LDA sprite_tile_array, X
  STA index_sprite
  
  JSR draw_1x1
  JSR shift_right
  INX

  LDA sprite_tile_array, X
  STA index_sprite
  JSR draw_1x1
  INX

  JSR shift_left
  LDA flip_state
  BEQ @continue

  ;--------------------------------- Mirrored Row tiles

  @invert_tiles:
    LDA tile_bit_mask  ;  Enable Horizontal Flip
    CLC
    ADC #$40
    STA tile_bit_mask

    JSR shift_right
    LDA sprite_tile_array, X
    STA index_sprite

    JSR draw_1x1
    INX

    JSR shift_left
    LDA sprite_tile_array, X

    STA index_sprite
    JSR draw_1x1
    INX

    LDA tile_bit_mask  ;  Disable Horizontal Flip
    SEC
    SBC #$40
    STA tile_bit_mask

  @continue:
    RTS
.endproc

.proc draw_1x1  ; RegY shows p1/p2 | RegX Mem Offset
  TXA                   ; Store tile arrary index
  PHA
  LDX temp2             ; Load Memory offset

  LDA sprite_y       ; Y position
  STA $0200, X

  LDA index_sprite      ; Tile Index
  STA $0201, X

  LDA tile_bit_mask     ; Attribte bitmask
  STA $0202, X

  LDA sprite_x       ; X position
  STA $0203, X

  JSR Increment_RegX_4  ; Increment Memory Offset
  STX temp2
  PLA
  TAX                   ; Return Tile array index to RegX

  RTS
.endproc

.proc Increment_RegX_4
  INX
  INX
  INX
  INX

  RTS
.endproc

.proc Increment_RegY_4
  INY
  INY
  INY
  INY

  RTS
.endproc

.proc Increment_RegY_16
  JSR Increment_RegY_4
  JSR Increment_RegY_4
  JSR Increment_RegY_4
  JSR Increment_RegY_4

  RTS
.endproc

.proc shift_right
  LDA sprite_x
  CLC
  ADC #$08
  STA sprite_x

  RTS
.endproc

.proc shift_left
  LDA sprite_x
  SEC
  SBC #$08
  STA sprite_x
  
  RTS
.endproc

.proc shift_down
  LDA sprite_y
  CLC
  ADC #$08
  STA sprite_y
  
  RTS
.endproc

.proc shift_up
  LDA sprite_y
  SEC
  SBC #$08
  STA sprite_y
  
  RTS
.endproc