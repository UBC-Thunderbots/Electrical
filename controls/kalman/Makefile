HEADERS = $(wildcard *.h)
SOURCES = $(wildcard *.cpp)
D_FILES = $(SOURCES:.cpp=.d)

CC = g++
CFLAGS = -g -Wall -O2
LFLAGS =  -L/usr/local/lib -lgsl -lgslcblas -lm
.PHONY all: main

main: main.o kalman.o matrix.o
	$(CC) -o $@ $(LFLAGS) $^

%.d: %.cpp $(HEADERS)
	$(CC) -MM $< -o $@

%.o: %.cpp %.d
	$(CC) $(CFLAGS) -c $<

.PHONY clean:
	rm -fr *.d
	rm -fr *.o
	rm -fr main

include $(D_FILES)
