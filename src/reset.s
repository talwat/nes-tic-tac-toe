.include "constants.inc"

.segment "CODE"
.import main
.export reset_handler
.proc reset_handler
  ; Fancy crap to whip the NES into shape.
  SEI
  CLD
  LDX #$40
  STX $4017
  LDX #$FF
  TXS
  INX
  STX $2000
  STX $2001
  STX $4010
  BIT $2002
vblankwait:
  BIT $2002
  BPL vblankwait

	LDX #$00
	LDA #$FF
clear_oam:
  ; Move all of the sprites off screen,
  ; this is to prevent garbled sprites before
  ; the NES is properly loaded.
	STA $0200,X
	INX
	INX
	INX
	INX
	BNE clear_oam

vblankwait2:
  BIT $2002
  BPL vblankwait2
  JMP main
.endproc
