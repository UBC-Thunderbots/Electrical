import json
import urllib.parse
import urllib.request

import digibom.partinfo

def url_for_part(part):
	params = [("name", part), ("lang", "en")]
	return "http://search.digikey.com/scripts/DkSearch/dksus.dll?Detail&" + urllib.parse.urlencode(params)

def lookup(part):
	def search_url_for_part(part):
		params = [("q", part), ("filters", "[[\"supplier\", [\"Digi-Key\"]]]")]
		return "http://octopart.com/api/v2/parts/search?" + urllib.parse.urlencode(params)

	def get_digikey_description_from_item(item):
		descriptions = item["descriptions"]
		for description in descriptions:
			if description["credit_domain"] == "digikey.com":
				return description["text"]
		raise Exception("Octopart search result contains no part description credited to digikey.com")

	# Find the part's information by submitting a search query to http://octopart.com/api/v2/parts/search?q=<partnum>&filters=[["supplier", ["Digi-Key"]]]
	url = search_url_for_part(part)
	with urllib.request.urlopen(url) as resp:
		if resp.getheader("Content-Type") != "text/plain; charset=utf-8":
			raise Exception("Octopart returned unexpected content-type")
		search_results = json.loads(str(resp.readall(), "UTF-8"))
	search_results = search_results["results"]
	for search_result in search_results:
		item = search_result["item"]
		offers = item["offers"]
		for offer in offers:
			if offer["supplier"]["displayname"] == "Digi-Key" and offer["sku"] == part:
				description = get_digikey_description_from_item(item)
				prices = []
				for offer_price in offer["prices"]:
					if offer_price[2] == "USD":
						prices.append(digibom.partinfo.Price(int(offer_price[0]), float(offer_price[1])))
				if len(prices) == 0:
					raise Exception("Octopart search result contains no prices for Digi-Key for this part")
				return digibom.partinfo.Part(part, description, prices, int(offer["avail"]))
	raise Exception("Octopart search result contains no offer from Digi-Key for this part")
