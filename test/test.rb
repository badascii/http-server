require 'minitest/autorun'
require 'minitest/spec'
require 'capybara'
require_relative '../lib/http'

Capybara.app = HTTP

describe HTTP do
  include Capybara::DSL

  describe 'server' do
    before do
      Capybara.reset_sessions!
      visit '/'
    end

    it 'should send a successful response' do
      page.status_code.must_equal(200)
    end
  end

end