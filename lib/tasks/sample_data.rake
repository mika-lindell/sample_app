namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    # First create admin
    admin = User.create!(name: "Ban Hammer",
                 email: "admin@banhammer.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    # Set admin.admin = true (defaults false)
    admin.toggle!(:admin)
    # Then iterate other users
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    # Create microposts for first six users
    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end

  end
end