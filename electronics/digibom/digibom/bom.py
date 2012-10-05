import math

import digibom.octopart
import digibom.partinfo

class BOM(object):
	def __init__(self, project_info):
		self._project_info = project_info
		self._parts = dict()
		self._part_info = None

	def add_list(self, filename, quantity):
		# Open the list file.
		with open(filename, encoding="UTF-8") as fp:
			# Check for the standard header.
			header = fp.readline()
			if not header.startswith("ref\tvalue"):
				raise Exception("Malformed KiCad list file (missing header)")

			# The rest of the lines should be components.
			for line in fp:
				# Break up the line into a reference designator, a component value, and optionally a DigiKey part number.
				fields = line.strip().split("\t")
				if len(fields) < 2:
					raise Exception("Malformed KiCad list file (fewer than two fields in a line)")
				reference = fields[0]
				value = fields[1]
				if len(fields) >= 3:
					part = fields[2]
				else:
					part = None

				# If there's no part number, we need to find it in the defaults table.
				if part is None:
					part = self._project_info.defaults.get(value)
					if part is None:
						raise Exception("Component {} has no part number but value {} does not appear in project info defaults table".format(reference, value))
					part = part.part

				# Add the part to the BOM, expanding multiparts.
				self.add_part(part, quantity)

	def add_part(self, part, quantity):
		mp = self._project_info.multiparts.get(part)
		if mp is not None:
			# This part is a multipart.
			# Recursively add all the subparts with appropriately-scaled quantities.
			for sp in mp.subparts:
				self.add_part(sp.id, sp.quantity * quantity)
		else:
			# This part is not a multipart.
			# Add it directly to the dictionary.
			old_quantity = self._parts.get(part, 0)
			self._parts[part] = old_quantity + quantity

	def apply_spares(self, absolute, relative):
		for part, quantity in self._parts.items():
			self._parts[part] = max(math.ceil(quantity * (1.0 + relative)), quantity + absolute)

	def load_part_info(self):
		self._part_info = digibom.partinfo.lookup(self._parts.keys())

	def check_quantity(self):
		first = True
		for part_id, quantity in self._parts.items():
			part_info = self._part_info[part_id]
			if part_info.quantity_available < quantity:
				if first:
					print()
					print("=== QUANTITY CHECK REPORT ===")
					first = False
				print("The order requires {} units of part {}, but only {} are available.".format(quantity, part_id, part_info.quantity_available))

	def write(self, outfile):
		with open(outfile, mode="w", encoding="UTF-8") as fp:
			for part_id, quantity in self._parts.items():
				part_info = self._part_info[part_id]
				price, quantity = part_info.get_effective_price_and_quantity(quantity)
				fp.write("{}\t{}\t{}\t{}\t{}\n".format(part_info.id, part_info.description, digibom.octopart.url_for_part(part_info.id), quantity, price))
