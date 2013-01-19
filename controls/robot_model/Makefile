SOURCES := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(SOURCES))
DEPENDS := $(patsubst %.cpp,%.d,$(SOURCES))

override CXXFLAGS := -g -std=gnu++0x $(CXXFLAGS)
override LDFLAGS := $(LDFLAGS)
override LIBS := $(LIBS)

robot_sim: $(OBJECTS)
	$(CXX) $(LDFLAGS) -o $@ $+ $(LIBS)

test: robot_sim
	./robot_sim > test

%.o:%.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

%.d:%.cpp
	$(CXX) $(CXXFLAGS) -o $@ -MM $^

.PHONY: clean
clean:
	$(RM) *.d
	$(RM) *.o 
	$(RM) robot_sim

include $(DEPENDS) 
