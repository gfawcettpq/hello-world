When(/^I check the service port$/) do
  @port_open = is_port_open?(ENV['ServiceURL'])
end

Then(/^the port should be open$/) do
  expect(@port_open).to be(true)
end
