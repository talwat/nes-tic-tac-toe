CC := ca65
LD := ld65

TARGET := game.nes
FLAGS := -C nes.cfg -o $(TARGET)
EMULATOR := fceux

.PHONY: all

all:
	$(MAKE) build
	$(MAKE) run
	$(MAKE) clean

run:
	$(EMULATOR) game.nes

build:
	for file in src/*.s; do $(CC) $$file; done
	$(LD) src/*.o $(FLAGS)

clean:
	@rm -fv *.nes src/*.o
