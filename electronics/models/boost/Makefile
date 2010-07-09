TARGETS := boost_model
SOURCES := $(wildcard *.cpp)
OBJTS := $(SOURCES:.cpp=.o)
DEPENDS := $(SOURCES:.cpp=.d)
CC=g++
LDFLAGS =
CFLAGS = -c

$(TARGETS):$(OBJTS) $(DEPENDS)	
	$(CC) $(LDFLAGS) $(OBJTS) -o $@

%.d:%.cpp
	$(CC) -MM $< -o $@

%.o:%.cpp
	$(CC) $(CFLAGS) $< -o $@

.PHONY:clean cleandep

cleandep:
	rm -f *.d

clean: cleandep
	rm -f *.o boost_model

include $(DEPENDS)
