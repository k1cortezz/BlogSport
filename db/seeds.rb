# Create initial admin user
User.create!(
  username: 'admin',
  email: 'admin@example.com',
  password: 'password123',
  fitness_stats: {
    weight: 70,
    height: 175,
    goal: 'maintenance'
  }
)

# Create some initial tags
['Workout', 'Nutrition', 'Cardio', 'Strength', 'Yoga', 'Recovery'].each do |tag_name|
  Tag.create!(name: tag_name)
end