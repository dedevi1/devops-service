from http.server import BaseHTTPRequestHandler, HTTPServer
import os

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            if os.getenv("FAIL") == "1":
            self.send_response(500)
                self.end_headers()
                self.wfile.write(b"FAIL")
            else:
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b"OK")
        else:
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"Service running")

server = HTTPServer(("0.0.0.0", 8080), Handler)
server.serve_forever()
