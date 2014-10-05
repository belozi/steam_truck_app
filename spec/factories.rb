FactoryGirl.define do 
	factory :user do 
		sequence(:first_name)	{ |n| "Person #{n}" }
		sequence(:last_name)	{ |n| "Family #{n}" }
		sequence(:email)		{ |n| "person_#{n}@steamtruck.org"}
		sequence(:school)		{ |n| "Example High School" }
		password				"password"
		password_confirmation 	"password"

		factory :admin do 
			admin true
		end
	end

	factory :post do 
		content "Lorem ipsum"
		user
	end

	factory :project do 
		project_title 	"Middle School Project"
		description		"We're at the Middle School solving problems"
		problem 		"The kids want to learn"
		solution		"Teach the kids"
		status			"In effect"
	end
end
