class Inventory(object):
	def __init__(self, filename):
		self._parts = dict()

		# Open the list file.
		with open(filename, encoding="UTF-8") as fp:
			# Check for the standard header.
			header = fp.readline()
			if not header.startswith("part\tquantity"):
				raise Exception("Malformed inventory file (missing header)")

			# The rest of the lines should be part/quantity pairs.
			for line in fp:
				# Break up the line into a part name and a quantity on hand.
				fields = line.strip().split("\t")
				if len(fields) != 2:
					raise Exception("Malformed inventory file (other than two fields in a line)")
				part = fields[0]
				quantity = float(fields[1])

				# Add the part to the inventory.
				self.add_part(part, quantity)

	def add_part(self, part, quantity):
		# Add the part to the dictionary.
		old_quantity = self._parts.get(part, 0)
		self._parts[part] = old_quantity + quantity

	def get_quantity(self, part):
		return self._parts.get(part, 0)
