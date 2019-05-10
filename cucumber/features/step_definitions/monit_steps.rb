When(/^I load the Monit Service Manager page$/) do
  auth = {username: 'admin', password: 'letmein'}

  @result = HTTParty.get("http://#{ENV['NodeIp']}", basic_auth: auth)
end

Then(/^I should see the logstash service running$/) do
  doc = Nokogiri::HTML(@result.parsed_response)

  @found_match = false

  doc.search('//tr').each do |line|
    @found_match = true if (line.search('a/text()').text.eql?('logstash') && line.search('td/font/text()').text.include?('running'))
    break if @found_match
  end

  expect(@found_match).to be(true)
end

Then(/^I should see the enabled service running$/) do
  doc = Nokogiri::HTML(@result.parsed_response)

  @found_match = false

  doc.search('//tr').each do |line|
    @found_match = true if (line.search('a/text()').text.eql?(ENV['ServiceName']) && line.search('td/font/text()').text.include?('running'))
    break if @found_match
  end

  expect(@found_match).to be(true)
end
