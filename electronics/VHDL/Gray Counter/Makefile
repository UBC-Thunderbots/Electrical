all: countertest

countertest: CounterTest.o GrayCounter.o
	ghdl -e --ieee=synopsys CounterTest

CounterTest.o: CounterTest.vhd
	ghdl -a --ieee=synopsys CounterTest.vhd

GrayCounter.o: GrayCounter.vhd
	ghdl -a --ieee=synopsys GrayCounter.vhd

wave: countertest
	ghdl -r CounterTest --vcd=Counter.vcd
	gtkwave Counter.vcd

clean:
	rm -fr GrayCounter.o
	rm -fr CounterTest.o
	rm -fr Counter.vcd
	rm -fr work-obj93.cf
	rm -fr countertest
	rm -fr *~
	rm -fr e~pidtest.o
