.include "constants.inc"
.include "header.inc"

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  ; Save registers
  PHA
  TXA
  PHA
  TYA
  PHA

  ; Transfer $0200-$02ff to the OAM
  ; This is our actual sprite data
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA

  ; Set the scroll position
  ; This isn't too important, just good practice
  LDA #$00
  STA $2005

  ; Restore registers
  PLA
  TAY
  PLA
  TAX
  PLA

  RTI
.endproc

.import reset_handler

.export main
.proc main
  ; Write Palettes
  LDX PPUSTATUS ; Select $3f00
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR
load_palettes:
  LDA palettes,X
  STA PPUDATA
  INX
  CPX #$20 ; 0x8 * 0x4 = 0x20
  BNE load_palettes

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10010000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK

forever:
  JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "RODATA"
palettes:
.byte $30, $16, $11, $0f
.byte $30, $00, $00, $00
.byte $30, $00, $00, $00
.byte $30, $00, $00, $00

.byte $30, $16, $11, $0f
.byte $10, $00, $00, $00
.byte $10, $00, $00, $00
.byte $10, $00, $00, $00

.segment "ZEROPAGE"
cursor_x: .res 1
cursor_y: .res 1
.exportzp cursor_x, cursor_y

.segment "CHR"
.incbin "graphics.chr"
