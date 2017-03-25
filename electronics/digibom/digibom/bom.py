#!/usr/bin/env python3
import math

import digibom.octopart
import digibom.partinfo

class BOM(object):
    def __init__(self, project_info):
        self._project_info = project_info
        self._parts = dict()
        self._part_info = None

    def kicad_to_list(self, filename):
        lf = []
        lf.append("ref\tvalue\tField1\tField2\tField3\tField4\tField5\tField6\tField7\tField8\r\n")
        with open(filename, encoding="UTF-8") as fp:
            # Check for the standard header.
            header = fp.readline()
            if not header.startswith("\"Id\";\"Designator\""):
                raise Exception("Malformed KiCad4 csv file (missing header)") 

            # Store the Kicad4 format into Kicad3
            for line in fp:
                fields = line.strip().split(";")
                if len(fields) < 6:
                    raise Exception("Malformed KiCad list file (fewer than six fields in a line)")
                designators = fields[1]
                value = fields[4]
                for designator in designators.strip().split(","):
                    lf.append("{}\t{}\r\n".format(designator, value))

        fp.close()

        # overwrite the file with the reformatted data
        with open(filename, 'w') as fp:
            for entry in lf:
                fp.write(entry)
        fp.close()
        #exit()

    def add_list(self, filename, quantity):
        # Convert the Kicad4 .csv file to the Kicad3 format.
        kicad_to_list(filename)

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
            self._parts[part] = max(quantity * (1.0 + relative), quantity + absolute)

    def subtract_inventory(self, inventory):
        to_erase = []
        for part, quantity in self._parts.items():
            self._parts[part] -= inventory.get_quantity(part)
            if self._parts[part] <= 0:
                to_erase.append(part)
        for part in to_erase:
            del self._parts[part]

    def round_quantities_up(self):
        for part, quantity in self._parts.items():
            self._parts[part] = math.ceil(self._parts[part])

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
