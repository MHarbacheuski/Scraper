# frozen_string_literal: true
require 'capybara'
require 'selenium/webdriver'
require 'webdrivers'


# scraps onliner
class Scraper
  attr_reader :start_page, :pages

  def initialize(start_page, pages_names)
    @start_page = start_page
    @pages = pages_names
  end

  def info
    browser = configure
    browser.visit 'https://www.onliner.by/'
    browser.click_on(start_page)

    headings = []
    img_hrefs = []
    descriptions = []

    pages.each { |name| inspect_page(browser, name, headings, img_hrefs, descriptions) }
    headings.zip(img_hrefs, descriptions)
  end

  private

  # конфиг capybara
  def configure
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end
    Capybara.default_driver = :selenium
    Capybara.javascript_driver = :chrome
    Capybara.match = :first
    Capybara.exact = :true
    Capybara.current_session
  end

  # проверка странички
  def inspect_page(browser, page_name, headings, img_hrefs, descriptions)
    browser.click_on(page_name)
    headings.concat(browser.all(class: 'news-tidings__subtitle').map(&:text))
    img_hrefs.concat(browser.all(class: 'news-tidings__image').map { |a| a['style'].match(/^.*:\s*url\((\".*\")\)/).captures[0] })
    descriptions.concat(browser.all(class: 'news-tidings__speech').map { |a| a.text.slice(0, 200) })
  end
end

