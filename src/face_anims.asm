.include "constants.inc"

.segment "ZEROPAGE"
.importzp sprite_animation_state, tile_bit_mask, flip_state, temp1, temp2
.importzp frame_counter, sprite_animation_state

.segment "CODE"
.import idle, rear, flipped_rear, yawn, happy, lenguetazo, right_1, right_2

.export walk_cycle, rear_cycle, forward_cycle

.proc walk_cycle
  LDA sprite_animation_state
  BNE @second_walk
  
  @first_walk:
    JSR right_1

  JMP @exit_walk
  
  @second_walk:
    JSR right_2

  @exit_walk:
  RTS
.endproc

.proc rear_cycle
  LDA sprite_animation_state
  BNE @second_walk
  
  @first_walk:
    JSR flipped_rear

  JMP @exit_walk
  
  @second_walk:
    JSR rear

  @exit_walk:
  RTS
.endproc

.proc forward_cycle
  @Normal:
    LDA frame_counter
    CMP #$21           ;  Compare every 36 frames
    BCS @state_4

    LDA frame_counter
    CMP #$16           ;  Compare every 24 frames
    BCS @state_3

    LDA frame_counter
    CMP #$0c           ;  Compare every 12 frames
    BCS @state_2
    
    JMP @state_1

  @state_4:
    JSR yawn
    
    JMP @exit_projectile

  @state_3:
    JSR lenguetazo

    JMP @exit_projectile

  @state_2:
    JSR yawn

    JMP @exit_projectile

  @state_1:
    JSR happy
  
  @exit_projectile:
    RTS 
.endproc