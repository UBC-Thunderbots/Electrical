import xml.sax
import xml.sax.handler

class Default(object):
	def __init__(self, value, part):
		self.value = value
		self.part = part

class Multipart(object):
	def __init__(self, id, subparts):
		self.id = id
		self.subparts = subparts

class Subpart(object):
	def __init__(self, id, quantity):
		self.id = id
		self.quantity = quantity

class ProjectInfo(object):
	def __init__(self, filename):
		if filename is not None:
			# Construct a SAX ContentHandler to use while loading the file.
			class ContentHandler(xml.sax.handler.ContentHandler):
				def __init__(self):
					xml.sax.handler.ContentHandler.__init__(self)
					self.multiparts = dict()
					self.defaults = dict()
					self._current_multipart = None

				def startElement(self, name, attrs):
					if name == "multipart":
						assert self._current_multipart is None
						self._current_multipart = (attrs.getValue("id"), [])
					elif name == "subpart":
						assert self._current_multipart is not None
						self._current_multipart[1].append(Subpart(attrs.getValue("id"), float(attrs.getValue("quantity"))))
					elif name == "default":
						value = attrs.getValue("value")
						part = attrs.getValue("part")
						if value in self.defaults:
							raise Exception("Duplicate value in defaults mapping")
						self.defaults[value] = Default(value, part)

				def endElement(self, name):
					if name == "multipart":
						assert self._current_multipart is not None
						mp = self._current_multipart
						self._current_multipart = None
						if mp[0] in self.multiparts:
							raise Exception("Duplicate ID in multipart table")
						self.multiparts[mp[0]] = Multipart(mp[0], mp[1])
			handler = ContentHandler()

			# Parse the file through the handler.
			xml.sax.parse(filename, handler)

			# Set our members to the collected data.
			self.defaults = handler.defaults
			self.multiparts = handler.multiparts
		else:
			self.defaults = dict()
			self.multiparts = dict()
