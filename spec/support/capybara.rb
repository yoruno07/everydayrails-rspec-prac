Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :chrome,
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
      chrome_options: {
        args: %w(headless disable-gpu window-size=1680,1050),
      },
    )
  )
end

Capybara.javascript_driver = :selenium
Capybara.default_max_wait_time = 15