require 'socket'

server = TCPServer.new('localhost', 2000)

loop do
  client  = server.accept
  request = client.gets

  STDERR.puts request

  response = "Hello World!\n"

  client.print("HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n")

  client.print "\r\n"
  client.print(response)
  client.close

end