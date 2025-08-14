# Clear existing data
puts "Clearing existing users..."
User.destroy_all

# Reset the auto-increment counter
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='users'") if ActiveRecord::Base.connection.adapter_name == 'SQLite'

puts "Creating seed users..."

# Create 1 admin user
admin_user = User.create!(
  first_name: "Admin",
  last_name: "User", 
  email: "admin@truthsandwich.com",
  position: "System Administrator",
  admin: true
)

puts "Created admin user: #{admin_user.full_name}"

# Create 9 regular employees
employees = [
  {
    first_name: "John",
    last_name: "Smith", 
    email: "john.smith@company.com",
    position: "Software Engineer"
  },
  {
    first_name: "Sarah", 
    last_name: "Johnson",
    email: "sarah.johnson@company.com", 
    position: "Product Manager"
  },
  {
    first_name: "Michael",
    last_name: "Brown",
    email: "michael.brown@company.com",
    position: "UX Designer"
  },
  {
    first_name: "Emily",
    last_name: "Davis", 
    email: "emily.davis@company.com",
    position: "Data Analyst"
  },
  {
    first_name: "David",
    last_name: "Wilson",
    email: "david.wilson@company.com", 
    position: "DevOps Engineer"
  },
  {
    first_name: "Jessica",
    last_name: "Miller",
    email: "jessica.miller@company.com",
    position: "Marketing Manager"
  },
  {
    first_name: "Robert",
    last_name: "Garcia",
    email: "robert.garcia@company.com",
    position: "Sales Representative"
  },
  {
    first_name: "Ashley",
    last_name: "Martinez", 
    email: "ashley.martinez@company.com",
    position: "HR Coordinator"
  },
  {
    first_name: "Christopher",
    last_name: "Anderson",
    email: "christopher.anderson@company.com",
    position: "QA Engineer"
  }
]

employees.each do |employee_data|
  user = User.create!(
    first_name: employee_data[:first_name],
    last_name: employee_data[:last_name],
    email: employee_data[:email], 
    position: employee_data[:position],
    admin: false
  )
  puts "Created employee: #{user.full_name} - #{user.position}"
end

puts "\nSeed completed successfully!"
puts "Total users created: #{User.count}"
puts "Admin users: #{User.where(admin: true).count}"
puts "Regular employees: #{User.where(admin: false).count}"

# Optional: Create a sample game for demonstration
if User.count >= 3
  puts "\nCreating a sample game..."
  
  sample_user = User.where(admin: false).first
  sample_game = Game.create!(
    user: sample_user,
    name: sample_user.full_name,
    position: sample_user.position,
    truth_1: "I once climbed Mount Kilimanjaro during a work vacation",
    truth_2: "I can speak three languages fluently", 
    lie: "I was born in Antarctica and lived there until age 5",
    active: false
  )
  
  puts "Created sample game for: #{sample_game.name}"
end

puts "\n🎮 Ready to play Truth Sandwich!"
puts "👤 Admin login: admin@truthsandwich.com"
puts "🏠 Visit: http://localhost:9292"
