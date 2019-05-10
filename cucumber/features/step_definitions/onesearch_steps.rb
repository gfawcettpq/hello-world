Given(/^I am on the onesearch homepage$/) do
  url = ENV['WebUrl']

  visit "https://#{url}"
end

Given(/^I wait for (\d+) seconds?$/) do |n|
  sleep(n.to_i)
end

Then(/^I should login to onesearch with the username "(.*?)" and the password "(.*?)"$/) do |username, password|
  sleep(20)
  fill_in('username', with: username, wait: 30)
  fill_in('password', with: password, wait: 30)
  click_link 'Log in'
end

Then("I should login to onesearch with the username and password loaded from ssm for dqc") do
  require 'aws-sdk'

  DQC_USER_MAP = {
    'Nightly' => 'Devopsnightly1!',
    'Nightly2' => 'Devopsnightly2!',
    'Nightly3' => 'Devopsnightly3!'
  }.freeze

  services_environment = ENV['ServicesEnvironment']

  ssm = Aws::SSM::Client.new

  username = DQC_USER_MAP[services_environment]

  password = ssm.get_parameter(
    name: "/devops/passwords/onesearch/academic/dqc/#{username.gsub('!', '')}",
    with_decryption: true
  ).parameter.value

  fill_in('username', with: username, wait: 30)
  fill_in('password', with: password, wait: 30)
  click_link 'Log in'
end

Then(/^I will search for "(.*?)"$/) do |search_term|
  fill_in 'searchTerm', :with => search_term
  click_link 'expandedSearch'
end

Then(/^I should click the first "(.*?)" link$/) do |link_text|
  click_link(link_text, match: :first)
end

Then(/^BIBS: I should click the first "(.*?)" link$/) do |link_id|
  click_link(link_id, match: :first)
end
