TARGET := boost_model
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

.PHONY: run plot
run: $(SAVE_FILE)

plot: $(SAVE_FILE)
	echo "load $(SAVE_FILE);plot(plots(:,1),plots(:,2:end));" | octave 

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
