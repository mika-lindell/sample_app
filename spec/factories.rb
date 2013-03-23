# Populate database for tests
FactoryGirl.define do
	factory :user do
		sequence(:name)  { |n| "Person #{n}" }
	  sequence(:email) { |n| "person_#{n}@example.com"}
	  password "foobar"
	  password_confirmation "foobar"

	  # This enables us to create admin with:
	  # FactoryGirl.create(:admin)
	  factory :admin do
      admin true
    end
	end

	factory :micropost do
    content "Lorem ipsum"
    user
  end
  
end