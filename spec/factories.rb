FactoryGirl.define do 
	factory :user do 
		first_name				"Robert"
		last_name				"Lee"
		email					"robert.belozi.lee@gmail.com"
		school					"Georgia State University"
		password				"password"
		password_confirmation 	"password"
	end
end
