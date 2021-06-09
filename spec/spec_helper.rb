# frozen_string_literal: true
require 'rspec/autorun'
require 'selenium/webdriver'
require 'capybara'


RSpec.configure do |config|

  config.before(:each, type: :feature) do
    # Note (Mike Coutermarsh): Make browser huge so that no content is hidden during tests
    Capybara.current_session.driver.browser.manage.window.resize_to(2_500, 2_500)
  end
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.javascript_driver = :chrome

Capybara.configure do |config|
  config.default_max_wait_time = 10 # seconds
  config.default_driver = :selenium
end


