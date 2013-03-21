# Create database stuff for tests
FactoryGirl.define do
  factory :user do
    name     "Mika Lindell"
    email    "mika@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end