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
  request_uri  = request_line.split(' ')[1]
  path         = URI.unescape(URI(request_uri).path)

  File.join(ROOT_URI, path)
end

server = TCPServer.new('localhost', 2000)

loop do
  client       = server.accept
  request_line = client.gets

  STDERR.puts(request_line)

  path = requested_file(request_line)

  if File.exist?(path) && !File.directory?(path)
    File.open(path, 'rb') do |file|
      client.print("HTTP/1.1 200 OK\r\n" +
                   "Content-Type: #{content_type(file)}\r\n" +
                   "Content-Length: #{file.size}\r\n" +
                   "Connection: close\r\n")

      client.print("\r\n")

      IO.copy_stream(file, client)
    end

  else
    message = "File not found\n"

    client.print("HTTP/1.1 404 Not Found\r\n" +
                 "Content-Type: text/plain\r\n" +
                 "Content-Length: #{message.size}\r\n" +
                 "Connection: close\r\n")

    client.print("\r\n")

    client.print(message)
  end

  client.close

end