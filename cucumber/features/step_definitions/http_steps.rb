Given("a request with AccountId {string} and GroupId {string} and DocId {string}") do |account_id, group_id, doc_id|
  builder = Builder::XmlMarkup.new

  @body = builder.DocRequest { |dr|
    dr.Subscription { |s|
      s.AccountId(account_id)
      s.GroupId(group_id)
    }
    dr.id(doc_id)
  }
end

When("I POST the request to the path {string}") do |path|
  protocol = 'true'.eql?(ENV['UseSSL']) ? 'https' : 'http'

  @result = HTTParty.post("#{protocol}://#{ENV['ServiceURL']}#{path}", body: @body)
end

Then("the response should contain {string}") do |match_me|
  expect(@result.body).to include(match_me)
end

When(/^I GET the path "(.*?)"$/) do |path|
  protocol = 'true'.eql?(ENV['UseSSL']) ? 'https' : 'http'

  @result = HTTParty.get("#{protocol}://#{ENV['ServiceURL']}#{path}")
end

When(/^I GET the self test resource$/) do
  @result = HTTParty.get("http://#{ENV['ServiceURL']}/#{ENV['resource_path']}/selftests")
end

Then(/^the response should be (\d+)$/) do |result|
  expect(@result.code.to_s).to eq(result.to_s)
end

Then(/^the result should be "(.*?)"$/) do |result|
  expect(@result.body).to eq(result)
end

Then(/^the "([^"]*)" result should be "([^"]*)"$/) do |key, value|
  response = JSON.parse(@result.body)
  expect(response[key]).to eq(value)
end

When(/^I query for "([^"]*)"$/) do |query|
  @result = HTTParty.get("http://#{ENV['ServiceURL']}/ac/onesearch/select/json?q=#{query}&sort=score+desc&start=0&rows=10&wt=json")
end

Then(/^the result should contain "([^"]*)"$/) do |something|
  puts @result
end

When(/^I GET the self test resource for "([^"]*)"$/) do |service|
  bits = service.split('-')
  type = bits[0]
  flavour = "#{bits[1]}-#{bits[2]}"

  response = HTTParty.get("http://#{ENV['ServiceURL']}/#{type}/#{flavour}/test/selftests")

  @result = JSON.parse(response.body)
end

Then(/^the status should be (\d+)$/) do |arg1|
  expect(@result['StatusCode']).to eq(200)
end

Then(/^the "([^"]*)" test should succeed$/) do |test|
  @result['TestResults'].each do |test_result|
    if test_result['Name'].eql? test
      expect(test_result['StatusCode']).to eq(200)
    end
  end
end

Then(/^the result should start with "([^"]*)"$/) do |something|
  @result.start_with? something
end

Then(/^the "([^"]*)" test should be "([^"]*)"$/) do |test, expected|
  require 'json'

  # strip the stupid OK from the rest of the JSON
  parsed = JSON.parse(@result)

  parsed[test].eql? expected
end

Then("the result should contain the versioned {string} url") do |service|
  services_version = ENV['ServicesVersion']
  service_url = "#{service}.v#{services_version}.dev.int.proquest.com"

  expect(@result.body).to include(service_url)
end

Then("the result should contain the versioned nightlyservices url") do
  services_version = ENV['ServicesVersion']
  service_url = "v#{services_version}nightlyservices.aa1.pqe"

  expect(@result.body).to include(service_url)
end

