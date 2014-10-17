require 'socket'
require 'uri'

class Server

  attr_reader :host, :port, :client

  ROOT_URI = './public'

  CONTENT_TYPE_MAPPING = {
  'html' => 'text/html',
  'txt'  => 'text/plain',
  'png'  => 'image/png',
  'jpg'  => 'image/jpeg'
  }

  DEFAULT_CONTENT_TYPE = 'application/octet-stream'

  def initialize(host, port=2000)
    @host  = host
    @port  = port
    @client = tcp_server.accept
  end

  def content_type(path)
    ext = File.extname(path).split('.').last
    CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
  end

  def requested_file(request_line)
    request_uri  = request_line.split(' ')[1]
    path         = URI.unescape(URI(request_uri).path)

    File.join(ROOT_URI, path)
  end

  def tcp_server
    TCPServer.new(host, port)
  end

  def run
    puts 'Starting server...'
    loop do
      client       = tcp_server.accept
      request_line = client.gets

      path = requested_file(request_line)

      puts "Got request for: #{path}"

      if valid_file?(path)
        serve_file(path, client)
      else
        file_not_found(client)
      end
      client.close
    end
  end

  def valid_file?(path)
    File.exist?(path) && !File.directory?(path)
  end

  def serve_file(path, client)
    File.open(path, 'rb') do |file|
      header = build_header(200, content_type(file), file.size)
      client.print(header)
      client.print("\r\n")

      IO.copy_stream(file, client)
    end
  end

  def file_not_found(client)
    message = "File not found\n"

    client.print("HTTP/1.1 404 Not Found\r\n" +
                 "Content-Type: text/plain\r\n" +
                 "Content-Length: #{message.size}\r\n" +
                 "Connection: close\r\n")

    client.print("\r\n")

    client.print(message)
  end

  def build_header(code, type, length)
    "HTTP/1.1 #{code} #{status_message(code)}\r\n" +
    "Content-Type: #{type}\r\n" +
    "Content-Length: #{length}\r\n" +
    "Connection: close\r\n"
  end

  def status_message(code)
    case code
    when 200
      'OK'
    when 404
      'Not Found'
    end
  end
end