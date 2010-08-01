
.PHONY: win clean

win: solenoid
	./solenoid

solenoid: main.o
	g++ -o solenoid main.o

main.o: main.cpp
	g++ -c -o main.o main.cpp

clean:
	rm -f main.o
	rm -f data.csv
	rm -f solenoid
