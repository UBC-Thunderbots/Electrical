HEADERS = $(wildcard *.h)
SOURCES = $(wildcard *.cpp)
D_FILES = $(SOURCES:.cpp=.d)
PACKAGES := gtkmm-2.4 glibmm-2.4 cairomm-1.0
CC 	= g++
EXE 	= parser replay stdderiv player
CFLAGS := -g -Wall -O2 $(shell pkg-config --cflags $(PACKAGES))
LFLAGS := -lgsl -lgslcblas -lm $(shell pkg-config --libs-only-other --libs-only-L $(PACKAGES))
LIBS   := $(shell pkg-config --libs-only-l $(PACKAGES))

.PHONY all: $(EXE)
.SILENT:

$(EXE): %:%.o
	echo "LD $*"
	$(CC) -o $@ $(LFLAGS) $^ $(LIBS)

%.d: %.cpp $(HEADERS)
	echo "DEP $*"
	$(CC) -MM $< -o $@

%.o: %.cpp %.d
	echo "CXX $*"
	$(CC) $(CFLAGS) -c $<

.PHONY clean:
	rm -fr *.d
	rm -fr *.o
	rm -fr main

include $(D_FILES)
