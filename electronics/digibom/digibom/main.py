import optparse

import digibom.bom
import digibom.projectinfo

# Application entry point.
def main():
	# Parse command-line options.
	parser = optparse.OptionParser(usage="%prog [options] list1 [qty1 [list2 [qty2 ...]]]", description="Merges lists of components from KiCad, fetches component information from Octopart, and generates order sheets.")
	parser.add_option("-o", "--out", type="string", dest="outfile", default="digibom.out", help="write BOM to FILE", metavar="FILE")
	parser.add_option("-s", "--spares", type="int", dest="spares", default=0, help="order at least SPARES more of each part than needed", metavar="SPARES")
	parser.add_option("-p", "--spares-percent", type="float", dest="spares_percent", default=0, help="order at least SP% (rounded up) more of each part than needed", metavar="SP")
	parser.add_option("-i", "--project-info", type="string", dest="project_info", default=None, help="read a project info file with default and multipart information", metavar="FILE")
	(options, args) = parser.parse_args()

	# Parse remaining arguments as (list, quantity) pairs.
	inputs = []
	for i in range(0, len(args), 2):
		filename = args[i]
		if len(args) > i + 1:
			quantity = int(args[i + 1])
		else:
			quantity = 1
		inputs.append((filename, quantity))
	if len(inputs) == 0:
		parser.error("At least one list file must be specified")

	# If a project information file was specified, load it now (otherwise will create an empty ProjectInfo).
	project_info = digibom.projectinfo.ProjectInfo(options.project_info)

	# Read all the list files specified on the command line, collecting part counts and expanding multiparts.
	bom = digibom.bom.BOM(project_info)
	for filename, quantity in inputs:
		bom.add_list(filename, quantity)

	# If spares have been requested, apply them now.
	if options.spares != 0 or options.spares_percent != 0:
		bom.apply_spares(options.spares, options.spares_percent / 100.0)

	# Load part information for the parts in the BOM.
	bom.load_part_info()

	# Check quantities if requested to do so.
	bom.check_quantity()

	# Write out the BOM.
	bom.write(options.outfile)
