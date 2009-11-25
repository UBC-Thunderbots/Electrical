all: pidtest

pidtest: PIDTest.o PIDController.o
	ghdl -e --ieee=synopsys PIDTest

PIDTest.o: PIDTest.vhd
	ghdl -a --ieee=synopsys PIDTest.vhd

PIDController.o: PIDController.vhd
	ghdl -a --ieee=synopsys PIDController.vhd

wave: pidtest
	ghdl -r PIDTest --vcd=PID.vcd

clean:
	rm -fr PIDController.o
	rm -fr PIDTest.o
	rm -fr PID.vcd
	rm -fr work-obj93.cf
	rm -fr pidtest
	rm -fr *~
	rm -fr e~pidtest.o
