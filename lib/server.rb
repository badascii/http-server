class Server

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

end