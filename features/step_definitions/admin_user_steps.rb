Given /^I am associated with the #{capture_model}$/ do |model_name|
  department = model!(model_name)
  AdminUser.last.departments << department
end

Given /^I try the password "([^"]*)" (\d+) times in a row$/ do |password, number|
  number.times do
    steps %Q(
      And I fill in "Email" with "admin@example.com"
      And I fill in "Password" with "#{password}"
      And I press "Log in"
      Then I should see "Invalid email/password combination"
    )
  end
end
