import json
import urllib.parse
import urllib.request

import digibom.partinfo

def url_for_part(part):
	params = [("name", part), ("lang", "en")]
	return "http://search.digikey.ca/scripts/DkSearch/dksus.dll?Detail&" + urllib.parse.urlencode(params)


def lookup(parts):
	def get_digikey_description_from_item(item):
		descriptions = item["descriptions"]
		# Use Digi-Key description first.
		for description in descriptions:
			if description["credit_domain"] == "digikey.com":
				return description["text"]
		# Last-ditch attempt, use generic description.
		return item["short_description"]

	max_lines_per_request = 20
	parts = [p for p in parts]
	ret = []
	for i in range(0, len(parts), max_lines_per_request):
		lines = [{"sku": part, "supplier": "Digi-Key", "limit": 20} for part in parts[i:min(len(parts), i + max_lines_per_request)]]
		params = {
			"lines": json.dumps(lines),
			"optimize.hide_datasheets": "1",
			"optimize.hide_images": "1",
			"optimize.hide_unauthorized_offers": "1",
			"optimize.hide_specs": "1",
			"apikey": "872e8dde",
		}
		url = "http://octopart.com/api/v2/bom/match?" + urllib.parse.urlencode(params)
		with urllib.request.urlopen(url) as resp:
			response = json.loads(resp.readall().decode("UTF-8"))
		for result in response["results"]:
			for item in result["items"]:
				for offer in item["offers"]:
					if offer["supplier"]["displayname"] == "Digi-Key" and offer["sku"] in parts:
						description = get_digikey_description_from_item(item)
						prices = []
						for offer_price in offer["prices"]:
							if offer_price[2] == "USD":
								prices.append(digibom.partinfo.Price(int(offer_price[0]), float(offer_price[1])))
						if len(prices) == 0:
							raise Exception("Octopart search result contains no prices for Digi-Key for this part")
						p = digibom.partinfo.Part(offer["sku"], description, prices, int(offer["avail"]))
						ret.append(p)
	return ret
