import html.parser
import re
import urllib.parse
import urllib.request

import digibom.partinfo

def url_for_part(part):
	params = [("name", part), ("lang", "en"), ("site", "CA")]
	return "http://search.digikey.com/scripts/DkSearch/dksus.dll?Detail&" + urllib.parse.urlencode(params)

def lookup(part):
	# A class to parse out all the table rows from an HTML file.
	class TableParser(html.parser.HTMLParser):
		def __init__(self):
			html.parser.HTMLParser.__init__(self)
			self.rows = []
			self._fields = []
			self._in_field = False
			self._text = ""

		def handle_starttag(self, tag, attrs):
			if tag == "tr":
				self._fields = []
				self._in_field = False
			elif tag == "td" or tag == "th":
				self._fields.append("")
				self._in_field = True

		def handle_data(self, data):
			self._text = self._text + data
			if self._in_field:
				self._fields[-1] = self._fields[-1] + data

		def handle_endtag(self, tag):
			if tag == "tr":
				self.rows.append(self._fields)
				self._fields = []
				self._in_field = False
			elif tag == "td" or tag == "th":
				self._in_field = False

		def is_part_not_found(self):
			return self._text.find("Part not found.") != -1

	# Download the HTML file.
	html_string = None
	url = url_for_part(part)
	while html_string is None:
		try:
			with urllib.request.urlopen(url) as resp:
				if resp.getheader("Content-Type") != "text/html; charset=utf-8":
					raise Exception("DigiKey returned unexpected content-type")
				html_string = str(resp.readall(), "UTF-8")
		except urllib.error.HTTPError as exp:
			if exp.code == 301:
				location = exp.headers["Location"]
				if location.startswith("/"):
					url = "http://search.digikey.com" + location
				else:
					raise
			else:
				raise
	
	# For some reason, DigiKey dumps weird tags in the middle of the HTML that look like this:
	# <CS=0>
	# <RF=141>
	#
	# These don't make the slightest bit of sense, and break HTMLParser.
	# Strip them out with a regular expression here.
	html_string = re.sub("<[^> ]+=[^>]+>", "", html_string)

	# Parse the HTML.
	parser = TableParser()
	parser.feed(html_string)
	rows = parser.rows

	# Check that the part was found.
	if parser.is_part_not_found():
		raise Exception("Part {} not found on DigiKey website".format(part))

	# Check that the correct currency is being reported.
	if rows.count(["All prices are in Canadian dollars."]) == 0:
		raise Exception("HTML file did not contain currency confirmation text")

	# Extract the list of prices from the prices table.
	header_index = rows.index(["Price Break", "Unit Price", "Extended Price\r\n"])
	prices = []
	for row in rows[header_index + 1:]:
		if len(row) == 3 and row[0].replace(",", "").isdigit():
			quantity = int(row[0].replace(",", ""))
			price = float(row[1].replace(",", ""))
			prices.append(digibom.partinfo.Price(quantity, price))
		else:
			break
	if len(prices) == 0:
		raise Exception("HTML file did not contain any recognizable quantity-price pairs")

	# Extract the part description and quantity available from the general information table.
	description = None
	quantity_available = None
	for row in rows:
		if len(row) == 2:
			if row[0] == "Description":
				description = row[1]
			elif row[0] == "Quantity Available":
				# Numbers are sometimes shown on the DigiKey site with commas, so remove that.
				s = row[1].replace(",", "").strip()
				# Sometimes there are notes or other text under the quantity available. Remove that too.
				for i in range(0, len(s)):
					if not s[i].isdigit():
						s = s[0:i]
						break
				# If quantity available is zero, there will be a form with form fields and a button.
				# There will be no actual ordinary text outside of element attributes.
				# That means we will end with an empty string in that case.
				if len(s) > 0:
					quantity_available = int(s)
				else:
					quantity_available = 0
	if description is None:
		raise Exception("HTML file did not contain any recognizable part description")
	if quantity_available is None:
		raise Exception("HTML file did not contain any recognizable part quantity available")

	return digibom.partinfo.Part(part, description, prices, quantity_available)
