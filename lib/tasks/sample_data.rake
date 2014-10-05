namespace :db do 
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
		make_posts
		make_relationships
		make_projects
	end
end

def make_users
	admin = User.create!(first_name: "Example", 
							last_name: "User",
							email: "example@steamtruck.org",
							school: "Example High School",
							password: "example",
							password_confirmation: "example",
							admin: true)
	99.times do |n|
		first_name  = Faker::Name.first_name
		last_name 	= Faker::Name.last_name
		email		= "example-#{n+1}@steamtruck.org"
		school 		= "Example High School"
		password 	= "foobar"
		User.create!(first_name: first_name,
							last_name: last_name,
							email: email,
							school: school,
							password: password,
							password_confirmation: password)
	end
end

def make_posts
	users = User.all(limit: 6)
	50.times do 
		content = Faker::Lorem.sentence(5)
		users.each { |user| user.posts.create!(content: content) }
	end
end

def make_relationships
	users 	= User.all
	user 	= users.first
	followed_users 	= users[2..50]
	followers 		= users[3..40]
	followed_users.each { |followed| user.follow!(followed) }
	followers.each		{ |follower| follower.follow!(user) }
end 

def make_projects
	users = User.all(limit: 3)
	2.times do 
		project_title = Faker::Lorem.sentence
		description = Faker::Lorem.sentence(5)
		problem = Faker::Lorem.sentence
		solution = Faker::Lorem.sentence
		status = Faker::Lorem.sentence
		users.each { |user| user.projects.create!(project_title: project_title, description: description, problem: problem, solution: solution, status: status) }
	end
end