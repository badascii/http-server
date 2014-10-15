require 'minitest/autorun'
require 'minitest/spec'
require 'net/http'
require_relative '../lib/server'

class TestServer < MiniTest::Unit::TestCase

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
    default_content_type = @server.content_type('asdf.blah')
    assert_equal(default_content_type, 'application/octet-stream')
  end
end