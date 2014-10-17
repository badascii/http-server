require 'socket'
require 'uri'
require 'gserver'

class Server < GServer

  attr_reader :host, :port

  ROOT_URI = './public'

  CONTENT_TYPE_MAPPING = {'html' => 'text/html',
                          'txt'  => 'text/plain',
                          'png'  => 'image/png',
                          'jpg'  => 'image/jpeg'}

  DEFAULT_CONTENT_TYPE = 'application/octet-stream'

  STATUS_MESSAGE = {200 => 'OK',
                    404 => 'Not Found'}

  def initialize(port=2000, *args)
    super(port, *args)
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

  def serve(io)
    loop do
      line = io.readline
      path = requested_file(line)

      puts "Got request for: #{path}"
      check_file(path, io)
    end
  end

  def check_file(path, client)
    if valid_file?(path)
      serve_file(path, client)
    else
      file_not_found(client)
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
    "HTTP/1.1 #{code} #{STATUS_MESSAGE[code]}\r\n" +
    "Content-Type: #{type}\r\n" +
    "Content-Length: #{length}\r\n" +
    "Connection: close\r\n"
  end

end