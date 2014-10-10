require 'socket'
require 'uri'

ROOT_URI = './public'

CONTENT_TYPE_MAPPING = {
  'html' => 'text/html',
  'txt'  => 'text/plain',
  'png'  => 'image/png',
  'jpg'  => 'image/jpeg'
}

DEFAULT_CONTENT_TYPE = 'application/octet-stream'

def content_type(path)
  ext = File.extname(path).split('.').last
  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
end

def requested_file(request_line)

end

server = TCPServer.new('localhost', 2000)

loop do
  client       = server.accept
  request_line = client.gets

  STDERR.puts(request_line)

  path = requested_file(request_line)

  response = "Hello World!\n"

  client.print("HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n")

  client.print "\r\n"
  client.print(response)
  client.close

end