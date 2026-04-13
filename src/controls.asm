.include "constants.inc"

.segment  "ZEROPAGE"
temp_controls:           .res 1

.importzp pads, prev_pads


.segment "CODE"
.export read_controllers


.proc read_controllers
  ; Store previously red controller inputs
  LDA pads
  BEQ @skip_prev

  STA prev_pads

  @skip_prev:
  ; Read new inputs
  LDA #$01
  STA CONTROLLER1
  LDA #$00
  STA CONTROLLER1
  
  JSR read_controller

  LDA temp_controls
  STA pads

  RTS
.endproc

.proc read_controller
  LDX #8
  LDA #$00
  STA temp_controls ; Store controller inputs

read_loop:
  LDA CONTROLLER1
  LSR A
  ROL temp_controls
  DEX
  BNE read_loop

  RTS
.endproc