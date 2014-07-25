namespace :db do 
	desc "Fill database with sample data"
	task populate: :environment do
		User.create!(first_name: "Example", 
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
end 