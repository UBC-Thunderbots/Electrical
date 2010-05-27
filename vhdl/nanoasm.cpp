#include <algorithm>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <tr1/unordered_map>
#include <cctype>
#include <cstdlib>

namespace {
	class instruction_pattern {
		public:
			enum ARG {
				// There is no argument here.
				ARG_NONE,
				// Name of register RA, can be literal as register is used read-only.
				ARG_RA_RO,
				// Name of register RA, literal not allowed as register is written to.
				ARG_RA_RW,
				// Name of register RB, can be literal as register is used read-only.
				ARG_RB_RO,
				// Name of register RB, literal not allowed as register is written to.
				ARG_RB_RW,
				// Value of constant CB, as an input port name.
				ARG_CB_IPORT,
				// Value of constant CB, as an output port name.
				ARG_CB_OPORT
			};
			instruction_pattern(const std::string &name, ARG arg1, ARG arg2, unsigned int opcode) : name(name), arg1(arg1), arg2(arg2), opcode(opcode) {
			}

			// The name of the instruction.
			const std::string name;

			// The types of the two arguments.
			const ARG arg1, arg2;

			// The opcode encoding of this instruction.
			const unsigned int opcode;
	};

	const instruction_pattern ALL_INSTRUCTIONS[] = {
		instruction_pattern("ADD", instruction_pattern::ARG_RA_RW, instruction_pattern::ARG_RB_RO, 0),
		instruction_pattern("ADDC", instruction_pattern::ARG_RA_RW, instruction_pattern::ARG_RB_RO, 12),
		instruction_pattern("CLAMP", instruction_pattern::ARG_RA_RW, instruction_pattern::ARG_RB_RO, 1),
		instruction_pattern("HALT", instruction_pattern::ARG_NONE, instruction_pattern::ARG_NONE, 2),
		instruction_pattern("IN", instruction_pattern::ARG_RA_RW, instruction_pattern::ARG_CB_IPORT, 3),
		instruction_pattern("MOV", instruction_pattern::ARG_RA_RW, instruction_pattern::ARG_RB_RO, 4),
		instruction_pattern("MUL", instruction_pattern::ARG_RA_RW, instruction_pattern::ARG_RB_RW, 5),
		instruction_pattern("NEG", instruction_pattern::ARG_RA_RW, instruction_pattern::ARG_RB_RO, 6),
		instruction_pattern("OUT", instruction_pattern::ARG_CB_OPORT, instruction_pattern::ARG_RA_RO, 7),
		instruction_pattern("SEX", instruction_pattern::ARG_RA_RW, instruction_pattern::ARG_RB_RO, 8),
		instruction_pattern("SHR32_1", instruction_pattern::ARG_RA_RW, instruction_pattern::ARG_RB_RW, 9),
		instruction_pattern("SHR32_2", instruction_pattern::ARG_RA_RW, instruction_pattern::ARG_RB_RW, 10),
		instruction_pattern("SHR32_4", instruction_pattern::ARG_RA_RW, instruction_pattern::ARG_RB_RW, 11),
		instruction_pattern("SKIPZ", instruction_pattern::ARG_RA_RO, instruction_pattern::ARG_NONE, 13),
	};

	const unsigned int NUM_REGS = 64;
	const unsigned int NUM_INSTRUCTIONS = 1024;

	class parser {
		public:
			parser() : current_section(SECTION_NONE), line_number(0), var_init(NUM_REGS, 0), next_var(0), next_iport(0), next_oport(0), instructions(NUM_INSTRUCTIONS, 0), instructions_emitted(NUM_INSTRUCTIONS, false), address(-1) {
			}

			void parse_line(std::string line) {
				++line_number;

				// Strip any comments.
				std::string::size_type idx = line.find(';');
				if (idx != std::string::npos) {
					line.erase(idx);
				}
				trim(line);
				if (line.empty()) {
					return;
				}
				if (line[0] == '.') {
					if (line == ".META") {
						current_section = SECTION_META;
					} else if (line == ".VARS") {
						current_section = SECTION_VARS;
					} else if (line == ".IPORTS") {
						current_section = SECTION_IPORTS;
					} else if (line == ".OPORTS") {
						current_section = SECTION_OPORTS;
					} else if (line == ".CODE") {
						current_section = SECTION_CODE;
					} else {
						std::cerr << "Error on line " << line_number << ": Unrecognized section name '" << line << "'!\n";
						std::exit(1);
					}
				} else if (current_section == SECTION_META) {
					std::istringstream iss(line);
					std::string name;
					char equals;
					std::string value;
					if (!(iss >> name >> equals >> value) || equals != '=') {
						std::cerr << "Error on line " << line_number << ": Expected <name> = <value>!\n";
						std::exit(1);
					}
					if (name == "Entity") {
						entity_name = value;
					} else {
						std::cerr << "Error on line " << line_number << ": Unrecognized meta name '" << name << "'!\n";
						std::exit(1);
					}
				} else if (current_section == SECTION_VARS) {
					std::istringstream iss(line);
					std::string name;
					char equals;
					int value;
					if (!(iss >> name >> equals >> value) || equals != '=') {
						std::cerr << "Error on line " << line_number << ": Expected <name> = <value>!\n";
						std::exit(1);
					}
					if (value < -32768 || value > 32767) {
						std::cerr << "Error on line " << line_number << ": Variable's initial value must be in range [-32768,32767]!\n";
						std::exit(1);
					}
					check_name(name);
					if (next_var == NUM_REGS) {
						std::cerr << "Error on line " << line_number << ": Too many registers!\n";
						std::exit(1);
					}
					vars[name] = next_var++;
					var_init[vars[name]] = value;
				} else if (current_section == SECTION_IPORTS) {
					check_name(line);
					if (next_iport == NUM_REGS) {
						std::cerr << "Error on line " << line_number << ": No more IPORTs available!\n";
						std::exit(1);
					}
					iports[line] = next_iport++;
					iport_names.push_back(line);
				} else if (current_section == SECTION_OPORTS) {
					std::istringstream iss(line);
					std::string name;
					char equals;
					int value;
					if (!(iss >> name >> equals >> value) || equals != '=') {
						std::cerr << "Error on line " << line_number << ": Expected <name> = <value>!\n";
						std::exit(1);
					}
					if (value < -32768 || value > 32767) {
						std::cerr << "Error on line " << line_number << ": Port's initial value must be in range [-32768,32767]!\n";
						std::exit(1);
					}
					check_name(name);
					if (next_oport == NUM_REGS) {
						std::cerr << "Error on line " << line_number << ": No more OPORTs available!\n";
						std::exit(1);
					}
					oports[name] = next_oport++;
					oport_init.push_back(value);
					oport_names.push_back(name);
				} else if (current_section == SECTION_CODE) {
					std::istringstream iss(line);
					std::vector<std::string> parts;
					{
						std::string part;
						while (iss >> part) {
							parts.push_back(part);
						}
					}
					if (parts.size() == 2 && parts[0] == "ORG") {
						char *end;
						unsigned long ul = std::strtoul(parts[1].c_str(), &end, 0);
						if (*end) {
							std::cerr << "Error on line " << line_number << ": Invalid address literal '" << parts[1] << "'!\n";
							std::exit(1);
						}
						if (ul > 1023) {
							std::cerr << "Error on line " << line_number << ": Address literal " << ul << " outside legal range [0,1023]!\n";
							std::exit(1);
						}
						address = static_cast<int>(ul);
					} else {
						if (address < 0) {
							std::cerr << "Error on line " << line_number << ": No code address has been specified!\n";
							std::exit(1);
						}
						if (address > 1023) {
							std::cerr << "Error on line " << line_number << ": Instruction stream runs past end of code memory!\n";
							std::exit(1);
						}
						if (instructions_emitted[address]) {
							std::cerr << "Error on line " << line_number << ": Emitting instruction at already-used address " << address << "!\n";
							std::exit(1);
						}
						bool found = false;
						for (unsigned int i = 0; i < sizeof(ALL_INSTRUCTIONS) / sizeof(*ALL_INSTRUCTIONS); ++i) {
							if (parts[0] == ALL_INSTRUCTIONS[i].name) {
								found = true;
								instructions[address] = emit(ALL_INSTRUCTIONS[i], parts);
								instructions_emitted[address] = true;
								++address;
							}
						}
						if (!found) {
							std::cerr << "Error on line " << line_number << ": Unknown instruction '" << parts[0] << "'!\n";
							std::exit(1);
						}
					}
				} else {
					std::cerr << "Error on line " << line_number << ": No section selected!\n";
					std::exit(1);
				}
			}

			const std::tr1::unordered_map<std::string, unsigned int> &get_iports() const {
				return iports;
			}

			const std::tr1::unordered_map<std::string, unsigned int> &get_oports() const {
				return oports;
			}

			unsigned int get_var_count() const {
				return next_var;
			}

			const std::vector<int> &get_var_init() const {
				return var_init;
			}

			const std::vector<int> &get_oport_init() const {
				return oport_init;
			}

			const std::vector<std::string> &get_iport_names() const {
				return iport_names;
			}

			const std::vector<std::string> &get_oport_names() const {
				return oport_names;
			}

			const std::vector<unsigned int> &get_instructions() const {
				return instructions;
			}

			const std::vector<bool> &get_instructions_emitted() const {
				return instructions_emitted;
			}

			unsigned int get_emitted_instruction_count() const {
				return std::count(instructions_emitted.begin(), instructions_emitted.end(), true);
			}

			const std::string &get_entity_name() const {
				return entity_name;
			}

		private:
			enum section {
				SECTION_NONE,
				SECTION_META,
				SECTION_VARS,
				SECTION_IPORTS,
				SECTION_OPORTS,
				SECTION_CODE
			} current_section;
			unsigned int line_number;
			std::tr1::unordered_map<std::string, unsigned int> vars, iports, oports;
			std::tr1::unordered_map<int, unsigned int> literals;
			std::vector<int> var_init;
			std::vector<std::string> iport_names, oport_names;
			std::vector<int> oport_init;
			unsigned int next_var, next_iport, next_oport;
			std::vector<unsigned int> instructions;
			std::vector<bool> instructions_emitted;
			std::string entity_name;
			int address;

			unsigned int emit(const instruction_pattern &ipat, const std::vector<std::string> &parts) {
				const instruction_pattern::ARG args[2] = {ipat.arg1, ipat.arg2};
				unsigned int num_args = 0;
				while (num_args < 2 && args[num_args] != instruction_pattern::ARG_NONE) ++num_args;
				if (parts.size() != num_args + 1) {
					std::cerr << "Error on line " << line_number << ": Expected " << num_args << " arguments to instruction '" << parts[0] << "' but found " << (parts.size() - 1) << "!\n";
					std::exit(1);
				}
				unsigned int encoding = ipat.opcode << 12;
				for (unsigned int i = 0; i < num_args; ++i) {
					if (args[i] == instruction_pattern::ARG_RA_RO) {
						unsigned int reg = find_var_or_literal(parts[i + 1]);
						encoding &= ~(0x3F << 6);
						encoding |= reg << 6;
					} else if (args[i] == instruction_pattern::ARG_RA_RW) {
						unsigned int reg = find_var(parts[i + 1]);
						encoding &= ~(0x3F << 6);
						encoding |= reg << 6;
					} else if (args[i] == instruction_pattern::ARG_RB_RO) {
						unsigned int reg = find_var_or_literal(parts[i + 1]);
						encoding &= ~0x3F;
						encoding |= reg;
					} else if (args[i] == instruction_pattern::ARG_RB_RW) {
						unsigned int reg = find_var(parts[i + 1]);
						encoding &= ~0x3F;
						encoding |= reg;
					} else if (args[i] == instruction_pattern::ARG_CB_IPORT) {
						if (!iports.count(parts[i + 1])) {
							std::cerr << "Error on line " << line_number << ": No such IPORT '" << parts[i + 1] << "'!\n";
							std::exit(1);
						}
						encoding &= ~0x3F;
						encoding |= iports[parts[i + 1]];
					} else if (args[i] == instruction_pattern::ARG_CB_OPORT) {
						if (!oports.count(parts[i + 1])) {
							std::cerr << "Error on line " << line_number << ": No such OPORT '" << parts[i + 1] << "'!\n";
							std::exit(1);
						}
						encoding &= ~0x3F;
						encoding |= oports[parts[i + 1]];
					}
				}

				return encoding;
			}

			unsigned int find_var_or_literal(const std::string &val) {
				if (std::isdigit(val[0]) || val[0] == '-') {
					return find_literal(val);
				} else {
					return find_var(val);
				}
			}

			unsigned int find_literal(const std::string &lit) {
				char *end;
				long lval = std::strtol(lit.c_str(), &end, 0);
				if (*end) {
					std::cerr << "Error on line " << line_number << ": Invalid integer literal '" << lit << "'!\n";
					std::exit(1);
				}
				int val = static_cast<int>(lval);
				return find_literal(val);
			}

			unsigned int find_literal(int val) {
				if (val < -32768 || val > 32767) {
					std::cerr << "Error on line " << line_number << ": Integer literal " << val << " outside legal range [-32768,32767]!\n";
					std::exit(1);
				}
				if (!literals.count(val)) {
					if (next_var == NUM_REGS) {
						std::cerr << "Error on line " << line_number << ": Too many registers!\n";
						std::exit(1);
					}
					literals[val] = next_var++;
					var_init[literals[val]] = val;
				}
				return literals[val];
			}

			unsigned int find_var(const std::string &var) {
				if (vars.count(var)) {
					return vars[var];
				} else {
					std::cerr << "Error on line " << line_number << ": No such variable '" << var << "'!\n";
					std::exit(1);
				}
			}

			static void trim(std::string &str) {
				while (str.size() > 0 && std::isspace(str[str.size() - 1])) {
					str.resize(str.size() - 1);
				}
				while (str.size() > 0 && std::isspace(str[0])) {
					str.erase(0, 1);
				}
			}

			void check_name(const std::string &name) {
				if (!is_name_ok(name)) {
					std::cerr << "Error on line " << line_number << ": Illegal name '" << name << "'!\n";
					std::exit(1);
				}
				if (vars.count(name) || iports.count(name) || oports.count(name)) {
					std::cerr << "Error on line " << line_number << ": Duplicate name '" << name << "'!\n";
					std::exit(1);
				}
			}

			static bool is_name_ok(const std::string &name) {
				if (name.empty()) return false;
				if (!std::isalpha(name[0])) return false;
				for (std::string::size_type i = 1; i < name.size(); ++i) {
					if (!std::isalnum(name[i])) return false;
				}
				return true;
			}
	};
}

int main() {
	std::string line;
	parser p;
	while (std::getline(std::cin, line)) {
		p.parse_line(line);
	}
	if (p.get_entity_name().empty()) {
		std::cerr << "Error: No Entity directive in .META section!\n";
		return 1;
	}

	unsigned int io_in_size = 1;
	unsigned int io_in_shift = 0;
	while (io_in_size < p.get_iports().size()) {
		io_in_size <<= 1;
		++io_in_shift;
	}

	unsigned int io_out_shift = 0;
	while ((1U << io_out_shift) < p.get_oports().size()) {
		++io_out_shift;
	}

	std::cout << "--\n";
	std::cout << "-- This file is automatically generated from an assembly language source file.\n";
	std::cout << "-- It is highly recommended not to edit this file.\n";
	std::cout << "-- To edit the machine code, edit the assembly source file and recompile it with nanoasm instead.\n";
	std::cout << "-- To edit the structure of the file, edit nanoasm's source code.\n";
	std::cout << "--\n";
	std::cout << "library ieee;\n";
	std::cout << "use ieee.std_logic_1164.all;\n";
	std::cout << "use ieee.numeric_std.all;\n";
	std::cout << "use work.types.all;\n";
	std::cout << "\n";
	std::cout << "entity " << p.get_entity_name() << " is\n";
	std::cout << "\tport(\n";
	for (std::vector<std::string>::const_iterator i = p.get_iport_names().begin(), iend = p.get_iport_names().end(); i != iend; ++i) {
		std::cout << "\t\t" << *i << " : in signed(15 downto 0);\n";
	}
	for (std::vector<std::string>::const_iterator i = p.get_oport_names().begin(), iend = p.get_oport_names().end(); i != iend; ++i) {
		std::cout << "\t\t" << *i << " : out signed(15 downto 0) := to_signed(" << p.get_oport_init()[p.get_oports().find(*i)->second] << ", 16);\n";
	}
	std::cout << "\t\tReset : in std_ulogic;\n";
	std::cout << "\t\tResetAddress : in unsigned(9 downto 0);\n";
	std::cout << "\t\tClock : in std_ulogic\n";
	std::cout << "\t);\n";
	std::cout << "end entity " << p.get_entity_name() << ";\n";
	std::cout << '\n';
	std::cout << "architecture Behavioural of " << p.get_entity_name() << " is\n";
	std::cout << "\tconstant InitROM : ROMDataType := (";
	for (unsigned int i = 0; i < NUM_INSTRUCTIONS; ++i) {
		if (p.get_instructions_emitted()[i]) {
			unsigned int instr = p.get_instructions()[i];
			std::cout << i << " => \"";
			for (unsigned int j = 16; j; --j) {
				std::cout << ((instr >> (j - 1)) & 1);
			}
			std::cout << "\",";
		}
	}
	std::cout << "others => \"0010000000000000\");\n";
	std::cout << "\tconstant InitRAM : RAMDataType := (";
	for (unsigned int i = 0; i < NUM_REGS; ++i) {
		int val = p.get_var_init()[i];
		if (val) {
			std::cout << i << " => to_signed(" << val << ", 16),";
		}
	}
	std::cout << "others => to_signed(0, 16));\n";
	std::cout << "\tsignal IOAddress : unsigned(5 downto 0);\n";
	std::cout << "\ttype IOInType is array(0 to " << (io_in_size - 1) << ") of signed(15 downto 0);\n";
	std::cout << "\tsignal IOIn : IOInType;\n";
	std::cout << "\tsignal IOInData : signed(15 downto 0);\n";
	std::cout << "\tsignal IOOutData : signed(15 downto 0);\n";
	std::cout << "\tsignal IOWrite : std_ulogic;\n";
	std::cout << "begin\n";
	std::cout << "\tCPUInstance : entity work.CPU(Behavioural)\n";
	std::cout << "\tgeneric map(\n";
	std::cout << "\t\tInitROM => InitROM,\n";
	std::cout << "\t\tInitRAM => InitRAM\n";
	std::cout << "\t)\n";
	std::cout << "\tport map(\n";
	std::cout << "\t\tClock => Clock,\n";
	std::cout << "\t\tReset => Reset,\n";
	std::cout << "\t\tResetAddress => ResetAddress,\n";
	std::cout << "\t\tIOAddress => IOAddress,\n";
	std::cout << "\t\tIOInData => IOInData,\n";
	std::cout << "\t\tIOOutData => IOOutData,\n";
	std::cout << "\t\tIOWrite => IOWrite\n";
	std::cout << "\t);\n";
	std::cout << '\n';
	for (unsigned int i = 0; i < io_in_size; ++i) {
		if (p.get_iport_names().size() > i) {
			std::cout << "\tIOIn(" << i << ") <= " << p.get_iport_names()[i] << ";\n";
		} else {
			std::cout << "\tIOIn(" << i << ") <= to_signed(0, 16);\n";
		}
	}
	std::cout << "\tIOInData <= IOIn(to_integer(IOAddress(" << (io_in_shift - 1) << " downto 0)));\n";
	std::cout << '\n';
	if (!p.get_oport_names().empty()) {
		std::cout << "\tprocess(Clock)\n";
		std::cout << "\tbegin\n";
		std::cout << "\t\tif rising_edge(Clock) then\n";
		std::cout << "\t\t\tif IOWrite = '1' then\n";
		for (unsigned int i = 0; i < p.get_oport_names().size(); ++i) {
			if (i == 0) std::cout << "\t\t\t\tif IOAddress(" << (io_out_shift - 1) << " downto 0) = to_unsigned(" << i << ", " << io_out_shift << ") then\n";
			else std::cout << "\t\t\t\telsif IOAddress(" << (io_out_shift - 1) << " downto 0) = to_unsigned(" << i << ", " << io_out_shift << ") then\n";
			std::cout << "\t\t\t\t\t" << p.get_oport_names()[i] << " <= IOOutData;\n";
		}
		std::cout << "\t\t\t\tend if;\n";
		std::cout << "\t\t\tend if;\n";
		std::cout << "\t\tend if;\n";
		std::cout << "\tend process;\n";
	}
	std::cout << "end architecture Behavioural;\n";

	std::cerr << '\n';
	std::cerr << "   Resource Utilization Report   \n";
	std::cerr << "---------------------------------\n";
	std::cerr << "Input ports:  " << p.get_iports().size() << '/' << NUM_REGS << "\t= " << ((p.get_iports().size() * 100 + (NUM_REGS / 2)) / NUM_REGS) << "%\n";
	std::cerr << "Output ports: " << p.get_oports().size() << '/' << NUM_REGS << "\t= " << ((p.get_oports().size() * 100 + (NUM_REGS / 2)) / NUM_REGS) << "%\n";
	std::cerr << "Variables:    " << p.get_var_count() << '/' << NUM_REGS << "\t= " << ((p.get_var_count() * 100 + (NUM_REGS / 2)) / NUM_REGS) << "%\n";
	std::cerr << "Instructions: " << p.get_emitted_instruction_count() << '/' << NUM_INSTRUCTIONS << "\t= " << ((p.get_emitted_instruction_count() * 100 + (NUM_INSTRUCTIONS / 2)) / NUM_INSTRUCTIONS) << "%\n";
	std::cerr << '\n';
	return 0;
}

