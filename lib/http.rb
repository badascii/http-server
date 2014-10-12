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

  if File.exist?(path) && !File.directory?(path)
    File.open(path, 'rb') do |file|
      client.print('HTTP/1.1 200 OK\r\n' +
                   'Content-Type: #{content_type(file)}\r\n' +
                   'Content-Length: #{file.size}\r\n' +
                   'Connection: close\r\n')

      client.print('\r\n')

      # write the contents of the file to the socket
      IO.copy_stream(file, socket)
    end

  else
    message = 'File not found\n'

    # respond with a 404 error code to indicate the file does not exist
    client.print('HTTP/1.1 404 Not Found\r\n' +
                 'Content-Type: text/plain\r\n' +
                 'Content-Length: #{message.size}\r\n' +
                 'Connection: close\r\n')

    socket.print('\r\n')

    socket.print(message)
  end

  socket.close

end