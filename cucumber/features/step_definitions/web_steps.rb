Given(/^I am on the homepage$/) do
  if 'true'.eql? ENV['UseSSL']
    safe_visit "https://#{ENV['WebUrl']}"
  else
    safe_visit "http://#{ENV['WebUrl']}"
  end
end

Given("I am on the page {string}") do |page|
  if 'true'.eql? ENV['UseSSL']
    safe_visit "https://#{ENV['WebUrl']}/#{page}"
  else
    safe_visit "http://#{ENV['WebUrl']}/#{page}"
  end
end

Then(/^I should wait for (\d+) seconds?$/) do |n|
  sleep(n.to_i)
end

Then(/^I should login with the username "(.*?)" and the password "(.*?)"$/) do |username, password|
  #sleep(20)
  fill_in('inputUsername', with: username, wait: 30)
  fill_in('inputPassword', with: password, wait: 30)
  #click_link 'Sign in'
end

Then(/^I should see "(.*?)"$/) do |expected_text|
  expect(page).to have_content(expected_text)
end

Given(/^I have loaded the appropriate credentials for "([^"]*)"$/) do |credentials_key|
	@username, @password = load_credentials_from_s3(credentials_key: credentials_key)
end

Then(/^I should login to PAM with my credentials$/) do
  sleep(10)
  fill_in('username', with: @username, wait: 30)
  fill_in('password', with: @password, wait: 30)
  click_on 'Log in'
end

Then(/^I should request the "([^"]*)" page$/) do |page_name|
	find(:xpath, "//a[@href='/#{page_name}']").click
end

Then(/^I should click the "([^"]*)" link$/) do |link_text|
  click_link(link_text)
end

Then(/^the "([^"]*)" select should have the option "([^"]*)"$/) do |select_name, option_value|
  expect(page).to have_select(select_name, with_options: [option_value])
end
