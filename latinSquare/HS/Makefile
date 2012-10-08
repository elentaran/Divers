EXEC=computeLS
CC=ghc
SRC=$(wildcard *.hs)

all: $(EXEC)


$(EXEC): $(SRC)
	$(CC) $(SRC) -o $(EXEC) 


clean:
	rm -f *.o
	rm -f *.hi
	rm -f *~
	rm -f $(EXEC)
