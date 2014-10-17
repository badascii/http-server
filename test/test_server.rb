require 'minitest/autorun'
require 'minitest/spec'
require 'net/http'
require_relative '../lib/server'

class TestServer < MiniTest::Test

  def setup
    @server = Server.new(2000, 'localhost')
  end

  def test_initialize
    assert_equal(@server.class, Server)
  end

  def test_default_content_type
    default_content_type = @server.content_type('file.blah')
    assert_equal(default_content_type, 'application/octet-stream')
  end

  def test_supported_file_types
    html = @server.content_type('a.html')
    assert_equal(html, 'text/html')

    txt  = @server.content_type('b.txt')
    assert_equal(txt, 'text/plain')

    png  = @server.content_type('c.png')
    assert_equal(png, 'image/png')

    jpg  = @server.content_type('d.jpg')
    assert_equal(jpg, 'image/jpeg')
  end

  def test_header
    code   = 200
    type   = Server::DEFAULT_CONTENT_TYPE
    length = 10
    header = @server.build_header(code, type, length)
    assert_equal(header, "HTTP/1.1 200 OK\r\n" +
                         "Content-Type: application/octet-stream\r\n" +
                         "Content-Length: 10\r\n" +
                         "Connection: close\r\n")
  end

  def test_status_message
    assert_equal(Server::STATUS_MESSAGE[200], 'OK')
    assert_equal(Server::STATUS_MESSAGE[404], 'Not Found')
  end

end