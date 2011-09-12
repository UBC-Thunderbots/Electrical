import contextlib
import errno
import os
import os.path
import sqlite3

import digibom.digikey
import digibom.xdg.basedir

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

def lookup(parts, include_quantity_available):
	# Open the database.
	conn = _open_cache();
	with contextlib.closing(conn):
		ret = dict()
		need_fetch = []

		# Look up all the parts in the database, only if available quantity was not requested.
		# For those that are present, stash their information.
		# For those that are not present, remember them.
		if not include_quantity_available:
			for part in parts:
				description = None
				prices = []
				cursor = conn.cursor()
				cursor.execute("SELECT description FROM parts WHERE id = ?", (part,))
				row = cursor.fetchone()
				if row is not None:
					description = row[0]
					cursor.execute("SELECT quantity, price FROM prices WHERE id = ?", (part,))
					for row in cursor:
						prices.append(Price(row[0], row[1]))
				if description is not None and len(prices) != 0:
					ret[part] = Part(part, description, prices)
				else:
					need_fetch.append(part)
		else:
			need_fetch = parts

		# If there are any parts requested that were not in the database, we need to download them.
		# We also need to download data for all parts of available quantity was requested.
		if len(need_fetch) != 0:
			# Show which parts are to be downloaded and ask the user for permission.
			if include_quantity_available:
				print("The following {} part(s) are present in the BOM:".format(len(need_fetch)))
			else:
				print("The following {} part(s) are not in your cache database:".format(len(need_fetch)))
			for part in need_fetch:
				print(part)
			print()
			if include_quantity_available:
				print("Part information must be downloaded from the DigiKey website to check available quantities as requested.")
				print()
			ch = ""
			while ch != "y" and ch != "n":
				ch = input("Download information about these parts from the DigiKey website? [y/n] ").lower()
			if ch == "n":
				raise Exception("Some part information needed to be downloaded and the user refused to allow the download.")

			# Download the data.
			for part in need_fetch:
				print("Looking up part {}...".format(part))
				part = digibom.digikey.lookup(part)
				ret[part.id] = part
				with conn:
					conn.execute("INSERT OR REPLACE INTO parts(id, description) VALUES (?, ?)", (part.id, part.description))
					for price in part.prices:
						conn.execute("INSERT OR REPLACE INTO prices(id, quantity, price) VALUES (?, ?, ?)", (part.id, price.quantity, price.price))
	
	return ret

def flush():
	conn = _open_cache()
	with contextlib.closing(conn):
		with conn:
			conn.execute("DELETE FROM parts")
		conn.execute("VACUUM")

def _open_cache():
	# Compute the directory to hold the cache database.
	cachedir = os.path.join(digibom.xdg.basedir.xdg_cache_home, "Thunderbots")

	# Create the directory if it doesn't already exist.
	try:
		os.makedirs(cachedir)
	except OSError as err:
		if err.errno != errno.EEXIST:
			raise

	# Open the database.
	cachefile = os.path.join(cachedir, "digibom.sqlite3")
	conn = sqlite3.connect(cachefile)

	# Bring the database's schema up to date if necessary.
	version = _get_user_version(conn)
	if version < len(_schema_upgraders):
		conn.execute("PRAGMA locking_mode = EXCLUSIVE")
		while version < len(_schema_upgraders):
			print("Upgrading cache database from version {} to version {}...".format(version, version + 1))
			_schema_upgraders[version](conn)
			version += 1
		conn.execute("PRAGMA locking_mode = NORMAL")
		conn.commit()
		_get_user_version(conn)
	elif version > len(_schema_upgraders):
		raise Exception("Schema version of partinfo cache too new for this digibom version")

	return conn

def _get_user_version(conn):
	cursor = conn.cursor()
	cursor.execute("PRAGMA user_version")
	row = cursor.fetchone()
	return row[0]

def _upgrade_schema_v0v1(conn):
	conn.execute("DROP TABLE IF EXISTS prices")
	conn.execute("DROP TABLE IF EXISTS parts")
	conn.commit()
	conn.execute("PRAGMA foreign_keys = ON")
	conn.commit()
	conn.execute("CREATE TABLE parts (id TEXT PRIMARY KEY NOT NULL CHECK(id <> ''), description TEXT NOT NULL CHECK(description <> ''))")
	conn.execute("CREATE TABLE prices (id TEXT NOT NULL REFERENCES parts(id) ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE, quantity INTEGER NOT NULL CHECK(quantity > 0), price REAL NOT NULL CHECK(price > 0), PRIMARY KEY(id, quantity))")
	conn.commit()
	conn.execute("PRAGMA user_version = 1")
	conn.commit()

_schema_upgraders = [
	_upgrade_schema_v0v1
]
