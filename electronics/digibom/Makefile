digibom : digibom.cpp
	$(CXX) -std=gnu++0x -Wall -Wextra -O2 -g -o$@ `pkg-config --cflags libxml++-2.6` $(CXXFLAGS) $+ `pkg-config --libs libxml++-2.6`

.PHONY : clean
clean :
	$(RM) digibom
