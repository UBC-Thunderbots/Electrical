#!/usr/bin/env python3
import json
import urllib.parse
import urllib.request

import digibom.partinfo

def url_for_part(part):
    params = [("name", part), ("lang", "en")]
    return "http://search.digikey.ca/scripts/DkSearch/dksus.dll?Detail&" + urllib.parse.urlencode(params)


def lookup(parts):
    def get_digikey_description_from_item(item):
        # Use Digi-Key description first.
        for description in item["descriptions"]:
            for source in description["attribution"]["sources"]:
                if source["name"] == "Digi-Key":
                    return description["value"]
        # Last-ditch attempt, use generic description.
        return item["short_description"]

    max_queries_per_request = 20
    parts = [p for p in parts]
    ret = []
    for i in range(0, len(parts), max_queries_per_request):
        queries = [{"sku": part, "seller": "Digi-Key", "limit": 20} for part in parts[i:min(len(parts), i + max_queries_per_request)]]
        params = {
            "queries": json.dumps(queries),
            "include[]": ["descriptions", "short_description"],
#            "optimize.hide_datasheets": "1",
#            "optimize.hide_images": "1",
#            "optimize.hide_unauthorized_offers": "1",
#            "optimize.hide_specs": "1",
            "apikey": "872e8dde",
        }
        url = "http://octopart.com/api/v3/parts/match?" + urllib.parse.urlencode(params, doseq=True)
        with urllib.request.urlopen(url) as resp:
            response = json.loads(resp.read().decode("UTF-8"))
        for result in response["results"]:
            for item in result["items"]:
                for offer in item["offers"]:
                    if offer["seller"]["name"] == "Digi-Key" and offer["sku"] in parts:
                        description = get_digikey_description_from_item(item)
                        prices = []
                        assert "USD" in offer["prices"], "Octopart search result contains no USD prices for Digi-Key for part {}".format(offer["sku"])
                        for offer_price in offer["prices"]["USD"]:
                            prices.append(digibom.partinfo.Price(int(offer_price[0]), float(offer_price[1])))
                        p = digibom.partinfo.Part(offer["sku"], description, prices, int(offer["in_stock_quantity"]))
                        ret.append(p)
    return ret
