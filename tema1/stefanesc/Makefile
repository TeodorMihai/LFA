CC = gcc
CFLAGS = -Wall -g

all: build

lexer.c: lexer.lex
	flex --outfile=$@ $<

build: lexer

lexer: lexer.o alphabet.o list.o expression.o context.o stack.o
	$(CC) $(CFLAGS) -o $@ $^ -lfl

.PHONY: clean

run: 
	./lexer $(arg)

clean:
	rm -f *.o *~ lexer.c lexer
