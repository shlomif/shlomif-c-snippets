all: afact cfact

cfact: fact.c
	gcc -m32 -Wall -O2 -o $@ $<

afact: fact.asm
	yasm -f elf32 $<
	gcc -m32 -Wall -o $@ fact.o

clean:
	rm -f afact cfact
