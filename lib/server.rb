class Server

  attr_accessor :host, :server

  CONTENT_TYPE_MAPPING = {
  'html' => 'text/html',
  'txt'  => 'text/plain',
  'png'  => 'image/png',
  'jpg'  => 'image/jpeg'
  }

  DEFAULT_CONTENT_TYPE = 'application/octet-stream'

  def initialize(host, port=2000)
    @host = host
    @port = port
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

  def create_tcp
    TCPServer.new(host, server)
  end


end