all: LFSRTest

LFSRTest: LFSRTest.o LFSR_10bit.o
	ghdl -e --ieee=synopsys LFSRTest

LFSRTest.o: LFSRTest.vhd
	ghdl -a --ieee=synopsys LFSRTest.vhd

LFSR_10bit.o: LFSR.vhd
	ghdl -a --ieee=synopsys LFSR.vhd

wave: LFSRTest
	ghdl -r LFSRTest --vcd=LFSR.vcd
	gtkwave LFSR.vcd

clean:
	rm -fr LFSR_10bit.o
	rm -fr LFSRTest.o
	rm -fr LFSR.vcd
	rm -fr work-obj93.cf
	rm -fr LFSRTest
	rm -fr *~
	rm -fr e~pidtest.o
