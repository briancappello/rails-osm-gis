# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

admin = User.create!(name: 'Example User',
             email: 'a@a.com',
             password: 'password',
             password_confirmation: 'password',
             admin: true)

35.times do ||
  admin.microposts.create!(content: Faker::Lorem.sentence)
end

99.times do |i|
  name = Faker::Name.name
  email = "a#{i+1}@a.com"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end

User.order(:created_at).take(5).each do |user|
  5.times do
    user.microposts.create!(content: Faker::Lorem.sentence)
  end
end

users = User.all
user = users.first
following = users[2..50]
following.each { |followed| user.follow(followed) }
followers = users[3..40]
followers.each { |follower| follower.follow(user) }
