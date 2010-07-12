TARGET := flyback_model
SOURCES := $(wildcard *.cpp)
OBJTS := $(SOURCES:.cpp=.o)
DEPENDS := $(SOURCES:.cpp=.d)
CC=g++
LDFLAGS =
CFLAGS = -c
SAVE_FILE = plots.csv
all: $(TARGET)

$(TARGET):$(OBJTS) $(DEPENDS)	
	$(CC) $(LDFLAGS) $(OBJTS) -o $@

.PHONY: run
run: $(SAVE_FILE)

$(SAVE_FILE): $(TARGET)
	./$(TARGET) $(SAVE_FILE)

%.d:%.cpp
	$(CC) -MM $< -o $@

%.o:%.cpp
	$(CC) $(CFLAGS) $< -o $@

.PHONY:clean cleandep cleansave

cleandep:
	rm -f $(DEPENDS)

cleansave:
	rm -f $(SAVE_FILE)

clean: cleandep cleansave
	rm -f $(OBJTS) $(TARGET)

include $(DEPENDS)
