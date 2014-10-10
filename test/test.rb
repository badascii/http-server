require 'minitest/autorun'
require 'minitest/spec'
require 'net/http'

class TestHTTP < MiniTest::Unit::TestCase

  def setup
    @uri = URI('http://localhost:2000/')
  end

  def test_hello_world
    response = Net::HTTP.get_response(@uri)
    assert(response.body.include?("Hello World!"))
  end

  def test_response_code
    response = Net::HTTP.get_response(@uri)
    assert_equal(response.code, '200')
  end

end