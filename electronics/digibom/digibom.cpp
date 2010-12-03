#include <algorithm>
#include <cerrno>
#include <cstddef>
#include <cstring>
#include <getopt.h>
#include <iostream>
#include <libgen.h>
#include <locale>
#include <queue>
#include <sstream>
#include <stdexcept>
#include <string>
#include <unistd.h>
#include <unordered_map>
#include <utility>
#include <vector>
#include <libxml++/libxml++.h>

namespace std {
	template<>
	class hash<Glib::ustring> {
		public:
			std::size_t operator()(const Glib::ustring &s) const {
				return underlying(s);
			}

		private:
			std::hash<std::string> underlying;
	};
}

namespace {
	unsigned int do_atoui(const char *str) {
		char *endptr;
		errno = 0;
		unsigned long ul = strtoul(str, &endptr, 10);
		if (errno) {
			const char *msg = std::strerror(errno);
			const std::string &msg_str = msg;
			throw std::runtime_error(msg_str);
		} else if (*endptr) {
			std::ostringstream oss;
			oss << "Error parsing integer, trailing text \"" << endptr << '"';
			throw std::runtime_error(oss.str());
		} else {
			return static_cast<unsigned int>(ul);
		}
	}

	unsigned int round_up(unsigned int x, unsigned int mod) {
		if (x % mod) {
			x += mod - (x % mod);
		}
		return x;
	}

	struct part_info {
		Glib::ustring description;
		Glib::ustring price;
		unsigned int minqty;

		part_info() {
		}

		part_info(const Glib::ustring &description, const Glib::ustring &price, unsigned int minqty) : description(description), price(price), minqty(minqty) {
		}
	};

	std::unordered_map<Glib::ustring, part_info> parts;
	std::unordered_map<Glib::ustring, std::unordered_map<Glib::ustring, unsigned int> > multiparts;
	std::unordered_map<Glib::ustring, Glib::ustring> defaults;

	void split(const Glib::ustring &input, gunichar delimiter, std::vector<Glib::ustring> &output) {
		output.push_back(std::string());
		for (Glib::ustring::const_iterator i = input.begin(), iend = input.end(); i != iend; ++i) {
			if (*i == delimiter) {
				output.push_back(Glib::ustring());
			} else {
				output.back().push_back(*i);
			}
		}
	}

	std::string do_readlink(const std::string &link) {
		std::vector<char> buf(4096);
		ssize_t rc;
		while ((rc = readlink(link.c_str(), &buf[0], buf.size())) >= 0 && static_cast<std::vector<char>::size_type>(rc) == buf.size()) {
			buf.resize(buf.size() * 2);
		}
		if (rc < 0) {
			throw std::runtime_error(std::string("readlink: ") + std::strerror(errno));
		}
		return std::string(buf.begin(), buf.begin() + rc);
	}

	std::string do_dirname(const std::string &path) {
		std::vector<char> buf(path.begin(), path.end());
		buf.push_back('\0');
		char *p = dirname(&buf[0]);
		if (!p) {
			throw std::runtime_error(std::string("dirname: ") + std::strerror(errno));
		}
		return p;
	}

	const xmlpp::Element *get_only_child_element(const xmlpp::Element *parent, const Glib::ustring &name) {
		const xmlpp::Node::NodeList &children = parent->get_children(name);
		if (children.size() != 1) {
			throw std::runtime_error("must be exactly one element of type " + name);
		}
		return dynamic_cast<const xmlpp::Element *>(*children.begin());
	}

	void check_for_recursive_expansion(const Glib::ustring &start) {
		std::unordered_map<Glib::ustring, Glib::ustring> parent;
		std::queue<Glib::ustring> q;
		q.push(start);
		parent[start] = "";
		while (!q.empty()) {
			const Glib::ustring &cur = q.front();
			typeof(multiparts.begin()) iter = multiparts.find(cur);
			if (iter != multiparts.end()) {
				const std::unordered_map<Glib::ustring, unsigned int> &m = multiparts.find(cur)->second;
				for (std::unordered_map<Glib::ustring, unsigned int>::const_iterator i = m.begin(), iend = m.end(); i != iend; ++i) {
					const Glib::ustring &next = i->first;
					if (parent.count(next)) {
						std::vector<Glib::ustring> v;
						v.push_back(next);
						Glib::ustring backptr = cur;
						while (!backptr.empty()) {
							v.push_back(backptr);
							backptr = parent[backptr];
						}
						std::reverse(v.begin(), v.end());
						Glib::ustring msg = "recursive expansion of part: ";
						bool first = true;
						for (std::vector<Glib::ustring>::const_iterator j = v.begin(), jend = v.end(); j != jend; ++j) {
							if (!first) {
								msg += " → ";
							}
							first = false;
							msg += *j;
						}
						throw std::runtime_error(msg);
					}
					parent[next] = cur;
					q.push(next);
				}
			}
			q.pop();
		}
	}

	void expand_part(const Glib::ustring &part, unsigned int quantity, std::unordered_map<Glib::ustring, unsigned int> &quantities) {
		if (parts.count(part)) {
			quantities[part] += quantity;
		} else if (multiparts.count(part)) {
			const typeof(multiparts.begin()->second) &mp = multiparts[part];
			for (typeof(mp.begin()) i = mp.begin(), iend = mp.end(); i != iend; ++i) {
				expand_part(i->first, quantity * i->second, quantities);
			}
		} else {
			throw std::runtime_error("missing part during expansion (should be impossible)");
		}
	}
}

#define OPT_VAL_IGNORE_MIN_QTY 256

int main(int argc, char **argv) {
	// Set to use the system's locale from environment variables.
	std::locale::global(std::locale(""));

	// Parse command-line options.
	unsigned int qty = 1;
	bool ignore_minqty = false;
	{
		bool help = false;
		static const char SHORT_OPTIONS[] = "hq:";
		static const option LONG_OPTIONS[] = {
			{ "help", no_argument, 0, 'h' },
			{ "quantity", required_argument, 0, 'q' },
			{ "ignore-min-qty", no_argument, 0, OPT_VAL_IGNORE_MIN_QTY },
			{ 0, 0, 0, 0 }
		};
		int ch;
		while ((ch = getopt_long(argc, argv, SHORT_OPTIONS, LONG_OPTIONS, 0)) != -1) {
			switch (ch) {
				case 'h':
					help = true;
					break;

				case 'q':
					qty = do_atoui(optarg);
					break;

				case OPT_VAL_IGNORE_MIN_QTY:
					ignore_minqty = true;
					break;

				default:
					help = true;
					break;
			}
		}

		if (help) {
			std::cerr << "Usage:\n" << argv[0] << " [options] < infile > outfile\n";
			std::cerr << '\n';
			std::cerr << "Options:\n";
			std::cerr << "{-q|--quantity} N      Generates an order sheet for N copies of the board\n";
			std::cerr << "--ignore-min-qty       Ignores the minimum order quantities (suitable for partial sheets that will be merged later)\n";
			return 1;
		}
	}

	// Parse the XML file into the hashtables.
	{
		xmlpp::DomParser parser;
		parser.set_validate();
		parser.set_substitute_entities();
		parser.parse_file(do_dirname(do_readlink("/proc/self/exe")) + "/partinfo.xml");
		const xmlpp::Element *root_elt = parser.get_document()->get_root_node();
		{
			const xmlpp::Element *parts_elt = get_only_child_element(root_elt, "parts");
			const xmlpp::Node::NodeList &children = parts_elt->get_children();
			for (xmlpp::Node::NodeList::const_iterator i = children.begin(), iend = children.end(); i != iend; ++i) {
				const xmlpp::Element *part_elt = dynamic_cast<const xmlpp::Element *>(*i);
				if (!part_elt || part_elt->get_name() != "part") {
					continue;
				}
				const Glib::ustring &id = part_elt->get_attribute_value("id");
				if (id.empty()) {
					throw std::runtime_error("attribute id of element part must be nonempty");
				}
				const Glib::ustring &description = get_only_child_element(part_elt, "description")->get_child_text()->get_content();
				const Glib::ustring &price = get_only_child_element(part_elt, "price")->get_child_text()->get_content();
				const Glib::ustring &minqty_str = part_elt->get_attribute_value("minqty");
				if (minqty_str.empty()) {
					throw std::runtime_error("attribute minqty of element part must be nonempty");
				}
				unsigned int minqty;
				if (ignore_minqty) {
					minqty = 1;
				} else {
					minqty = do_atoui(minqty_str.c_str());
				}
				if (!minqty) {
					throw std::runtime_error("attribute minqty of element part must be nonzero");
				}
				if (parts.count(id)) {
					throw std::runtime_error(Glib::ustring::compose("duplicate part \"%1\"", id));
				}
				parts[id] = part_info(description, price, minqty);
			}
		}
		{
			const xmlpp::Element *multiparts_elt = get_only_child_element(root_elt, "multiparts");
			const xmlpp::Node::NodeList &children = multiparts_elt->get_children();
			for (xmlpp::Node::NodeList::const_iterator i = children.begin(), iend = children.end(); i != iend; ++i) {
				const xmlpp::Element *multipart_elt = dynamic_cast<const xmlpp::Element *>(*i);
				if (!multipart_elt || multipart_elt->get_name() != "multipart") {
					continue;
				}
				const Glib::ustring &id = multipart_elt->get_attribute_value("id");
				if (id.empty()) {
					throw std::runtime_error("attribute id of element multipart must be nonempty");
				}
				std::unordered_map<Glib::ustring, unsigned int> subparts;
				const xmlpp::Node::NodeList &subpart_elts = multipart_elt->get_children();
				for (xmlpp::Node::NodeList::const_iterator j = subpart_elts.begin(), jend = subpart_elts.end(); j != jend; ++j) {
					const xmlpp::Element *subpart_elt = dynamic_cast<const xmlpp::Element *>(*j);
					if (!subpart_elt || subpart_elt->get_name() != "subpart") {
						continue;
					}
					const Glib::ustring &qty_string = subpart_elt->get_attribute_value("qty");
					unsigned int qty;
					if (qty_string.empty()) {
						qty = 1;
					} else {
						qty = atoi(qty_string.c_str());
						if (!qty) {
							throw std::runtime_error("attribute qty of element subpart must be a natural number");
						}
					}
					const Glib::ustring &subpart_name = subpart_elt->get_child_text()->get_content();
					if (subparts.count(subpart_name)) {
						throw std::runtime_error(Glib::ustring::compose("duplicate subpart \"%1\"", subpart_name));
					}
					subparts[subpart_name] = qty;
				}
				if (multiparts.count(id)) {
					throw std::runtime_error(Glib::ustring::compose("duplicate multipart \"%1\"", id));
				}
				multiparts[id] = subparts;
			}
		}
		{
			const xmlpp::Element *defaults_elt = get_only_child_element(root_elt, "defaults");
			const xmlpp::Node::NodeList &children = defaults_elt->get_children();
			for (xmlpp::Node::NodeList::const_iterator i = children.begin(), iend = children.end(); i != iend; ++i) {
				const xmlpp::Element *default_elt = dynamic_cast<const xmlpp::Element *>(*i);
				if (!default_elt || default_elt->get_name() != "default") {
					continue;
				}
				const Glib::ustring &value = default_elt->get_attribute_value("value");
				if (value.empty()) {
					throw std::runtime_error("attribute value of element default must be nonempty");
				}
				const Glib::ustring &part = default_elt->get_attribute_value("part");
				if (part.empty()) {
					throw std::runtime_error("attribute part of element default must be nonempty");
				}
				defaults[value] = part;
			}
		}
	}

	// Sanity-check the data in the hashtables.
	for (typeof(multiparts.begin()) i = multiparts.begin(), iend = multiparts.end(); i != iend; ++i) {
		for (typeof(i->second.begin()) j = i->second.begin(), jend = i->second.end(); j != jend; ++j) {
			if (!parts.count(j->first) && !multiparts.count(j->first)) {
				throw std::runtime_error(Glib::ustring::compose("multipart has nonexistent subpart \"%1\"", j->first));
			}
		}
		check_for_recursive_expansion(i->first);
	}

	// Read the first line of the list file, which should be a header.
	std::string line;
	if (!std::getline(std::cin, line)) {
		throw std::runtime_error("missing header");
	}
	if (line != "ref\tvalue") {
		throw std::runtime_error("malformed header");
	}

	// Keep a record of the number of each part seen.
	std::unordered_map<Glib::ustring, unsigned int> quantities;

	// Read the other lines and translate them.
	while (std::getline(std::cin, line)) {
		std::vector<Glib::ustring> columns;
		split(line, '\t', columns);
		Glib::ustring base_part;
		if (columns.size() < 2 || columns[0].empty() || columns[1].empty()) {
			throw std::runtime_error("malformed input line has fewer than 2 columns");
		} else if (columns.size() < 3 || columns[2].empty()) {
			// There is only a reference and a value. Look for the value in the defaults map.
			if (!defaults.count(columns[1])) {
				throw std::runtime_error(Glib::ustring::compose("part \"%1\" has no part number and value \"%2\" not in defaults table", columns[0], columns[1]));
			}
			base_part = defaults[columns[1]];
		} else {
			// There are three or more columns. The third column is the part number.
			base_part = columns[2];
		}
		// Check that the part number exists.
		if (!multiparts.count(base_part) && !parts.count(base_part)) {
			throw std::runtime_error(Glib::ustring::compose("part \"%1\" has nonexistent part number \"%2\"", columns[0], base_part));
		}
		// Expand the part number through the multipart map.
		expand_part(base_part, 1, quantities);
	}

	// Generate output.
	for (typeof(quantities.begin()) i = quantities.begin(), iend = quantities.end(); i != iend; ++i) {
		const part_info &pi = parts[i->first];
		unsigned int req_qty = i->second * qty;
		unsigned int order_qty = round_up(req_qty, pi.minqty);
		std::cout << pi.description << '\t' << i->first << "\thttp://search.digikey.com/scripts/DkSearch/dksus.dll?Detail&name=" << i->first << '\t' << order_qty << '\t' << pi.price << '\n';
	}

	return 0;
}

