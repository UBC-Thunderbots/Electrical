#!/usr/bin/env python3
import contextlib
import errno
import os
import os.path

import digibom.octopart

class Part(object):
    def __init__(self, id, description, prices, quantity_available=None):
        self.id = id
        self.description = description
        self.prices = prices
        self.quantity_available = quantity_available

    def get_effective_price_and_quantity(self, requested_quantity):
        best = None
        for price in self.prices:
            cur = price.get_effective_price_and_quantity(requested_quantity)
            if best is None or (cur[0] * cur[1]) < (best[0] * best[1]):
                best = cur
        return best

class Price(object):
    def __init__(self, quantity, price):
        self.quantity = quantity
        self.price = price

    def get_effective_price_and_quantity(self, requested_quantity):
        return self.price, max(self.quantity, requested_quantity)

def lookup(parts):
    results = digibom.octopart.lookup(parts)
    ret = {}
    for part in results:
        ret[part.id] = part
    return ret
