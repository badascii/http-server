require 'minitest/autorun'
require 'minitest/spec'
require 'net/http'
require_relative '../lib/server'

class TestServer < MiniTest::Test

  def setup
    @server = Server.new('localhost', 2000)
  end

  def test_initialize
    assert_equal(@server.class, Server)
  end

  def test_create_tcp
    tcp = @server.create_tcp
    assert_equal(tcp.class, TCPServer)
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
end