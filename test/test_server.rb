require 'minitest/autorun'
require 'minitest/spec'
require 'net/http'
require_relative '../lib/server'

class TestServer < MiniTest::Unit::TestCase

  def setup
    @server = Server.new
  end

  def test_initialize
    assert_equal(@server.class, Server)
  end
end