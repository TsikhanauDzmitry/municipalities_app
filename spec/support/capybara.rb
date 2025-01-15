# frozen_string_literal: true

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.javascript_driver = :selenium_chrome_headless

# By the default, HTML screenshots will not look very good when opened in a browser.
# This happens because the browser can't correctly resolve relative paths like
# <link href="/assets/...." />, which stops CSS, images, etc... from being loaded.
# To get a nicer looking page, configure Capybara with:
Capybara.asset_host = 'http://localhost:3000'

# Override the basename for screenshots with the spec example full description
Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  "screenshot_#{example.full_description.parameterize}"
end

RSpec.configure do |config|
  config.before(:each, :js) do
    Capybara.page.current_window.resize_to(1024, 768)
  end
end
