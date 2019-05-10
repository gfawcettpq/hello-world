require 'aws-sdk'
require 'aws-sdk-v1'
require 'builder'
require 'capybara/cucumber'
require 'capybara-screenshot/cucumber'
require 'capybara/poltergeist'
require 'httparty'
require 'json'
require 'nokogiri'
require 'rspec/expectations'
require 'selenium-webdriver'
require 'socket'
require 'timeout'
require 'yaml'

# checks to see if the specified port is open
def is_port_open?(url)
  ip, port = url.split(':')
  begin
    Timeout::timeout(1) do
      begin
        s = TCPSocket.new(ip, port)
        s.close
        return true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        return false
      end
    end
  rescue Timeout::Error
  end

  return false
end

# loads encrypted credentials from S3 via KMS
# TODO - replace with new SMSR Parameter Store
def load_credentials_from_s3(options = {})
  bucket = 'pq-devops'
  prefix = "secrets/#{options[:credentials_key]}.credentials"

  s3 = AWS::S3.new
  kms = Aws::KMS::Client.new(region: AWS.config.region)

  begin
    ciphertext = s3.buckets[bucket].objects[prefix].read
  rescue AWS::S3::Errors::NoSuchKey
    raise "required credentials not found :: #{options[:credentials_key]}"
  end

  response = kms.decrypt(ciphertext_blob: ciphertext)

  if response.successful?
    credentials = YAML.load(response.data.plaintext)

		return credentials['username'], credentials['password']
  else
    raise "unable to decrypt stored credentials #{response.error}"
  end

end

# determines the protocol (HTTP/HTTPS) that is available
def protocol(url)
  begin
    puts "trying http://#{url}"

    response = HTTParty.get("http://#{url}")
    return 'http' if response.success?

    puts "trying https://#{url}"

    response = HTTParty.get("https://#{url}", verify: false)
    return 'https' if response.success?

    raise "unable to determine protocol"
  end
end

def safe_visit(url)
  max_retries = 3
  times_retried = 0

  begin
    visit url
  rescue Net::ReadTimeout => error
    if times_retried < max_retries
      times_retried += 1
      puts "failed to visit #{url}, retry #{times_retried}/#{max_retries}"
      retry
    else
      puts error.message
      puts error.backtrace.inspect
      exit 1
    end
  end
end

Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: [
        '--disable-default-apps',
        '--disable-extensions',
        '--disable-infobars',
        '--disable-notifications',
        '--disable-password-generation',
        '--disable-password-manager-reauthentication',
        '--disable-password-separated-signin-flow',
        '--disable-popup-blocking',
        '--disable-save-password-bubble',
        '--disable-translate',
        '--incognito',
        '--mute-audio',
        '--no-default-browser-check',
        '--window-size=1280,1024'
      ]
    },
    prefs: {
      download: { prompt_for_download: false },
      credentials_enable_service: false,
      profile: {
        password_manager_enabled: false,
        default_content_settings: { popups: 0 },
        content_settings: {
          pattern_pairs: {
            '*' => { 'multiple-automatic-downloads' => 1 }
          }
        }
      }
    }
  )

  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 240
  client.open_timeout = 240

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV['SELENIUM_HUB'] || "http://selenium-hub.dev.int.proquest.com/wd/hub",
    desired_capabilities: capabilities,
    http_client: client
  )
end

Capybara::Screenshot.autosave_on_failure = false
Capybara::Screenshot.prune_strategy = :keep_last_run

After do |scenario|
  if scenario.failed?
    add_screenshot
    add_browser_logs
  end
end

def add_screenshot
  file_path = 'screenshot.png'
  page.driver.browser.save_screenshot(file_path)
end

def add_browser_logs
  logs = page.driver.browser.manage.logs.get(:browser).map { |line| [line.level, line.message] }

  puts "logs: #{logs}"

  File.write('console.log', logs.join("\n"))
end

if ENV['TestEnvironment'].eql? 'local'
  Capybara.default_driver = :selenium
else
  Capybara.javascript_driver = :chrome
  Capybara.default_driver = Capybara.javascript_driver
end
Capybara.default_max_wait_time = 15
Capybara.server_host = '0.0.0.0'
Capybara.always_include_port = true
