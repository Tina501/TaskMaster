# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning database..."
Collaboration.destroy_all
User.destroy_all
Task.destroy_all

puts "Creating users..."
# Create 10 users with avatars

user = User.create!(
  email: "test@test.com",
  password: "password",
)

10.times do
  user = User.create!(
    email: Faker::Internet.email,
    password: "password",
  )
  puts "Created user: #{user.email}"
end

puts "Creating tasks..."
# Create sample tasks
1000.times do
  user = rand < 0.8 ? User.find_by(email: "test@test.com") : User.all.sample

  # Generate a random time between Jan 2025 and Jan 2026
  random_time = rand(Time.new(2025, 1, 1)..Time.new(2026, 1, 1))

  task = Task.create!(
    title: Faker::Lorem.sentence,
    description: Faker::Lorem.paragraph,
    deadline: random_time,
    priority: rand(1..3),
    completed: [true, false].sample,
    user: user
  )

  # Randomly assign 1-3 collaborators to each task
  [User.all.sample(rand(1..3)) - [user]].flatten.each do |user|
    Collaboration.create!(
      task: task,
      user: user
    )
  end

  puts "Created task: #{task.title} with #{task.collaborators.count} collaborators"
end

puts "Seeding completed! Created:"
puts "- #{User.count} users"
puts "- #{Task.count} tasks"
puts "- #{Collaboration.count} collaborations"
