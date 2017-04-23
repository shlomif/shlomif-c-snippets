all: afact cfact

cfact: fact.c
	gcc -Wall -O2 -o $@ $<

afact: fact.asm
	yasm -f elf32 $<
	gcc -Wall -o $@ fact.o

clean:
	rm -f cfact
