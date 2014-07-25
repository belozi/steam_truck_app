require 'spec_helper'

describe "UserPages" do

	subject { page }

    describe "index" do 

        let(:user)      { FactoryGirl.create(:user) }

        before do
            sign_in user
            visit users_path
        end

        it { should have_title('All users') }
        it { should have_content('All users') }

        describe "pagination" do 

            before(:all)    { 30.times { FactoryGirl.create(:user) } }
            after(:all)     { User.delete_all }

            it { should have_selector('div.pagination') }


            it "should list each user" do 
                User.paginate(page: 1).each do |user|
                    expect(page).to have_selector("li", text: "#{user.first_name} #{user.last_name}")
                end
            end
        end

        describe "delete links" do 

            it { should_not have_link('delete') }

            describe "as an admin user" do 
                let(:admin) { FactoryGirl.create(:admin) }
                before do 
                    sign_in admin
                    visit users_path
                end

                it { should have_link('delete', href: user_path(User.first)) }
                it "should be able to delete another user" do 
                    expect do 
                        click_link('delete', match: :first)
                    end.to change(User, :count).by(-1)
                end

                it { should_not have_link('delete', href: user_path(admin)) }
            end
        end
    end


    describe "profile page" do
    	let(:user) 	{ FactoryGirl.create(:user) }
    	before 		{ visit user_path(user) }

    	it { should have_content("#{user.first_name} #{user.last_name}") }
    	it { should have_title("#{user.first_name} #{user.last_name}") }
    end

    describe "signup page" do 
		before { visit signup_path }

		it { should have_content('Sign up') }
		it { should have_title(full_title('Sign up')) }
    end

    describe "signup" do 

    	before 			{ visit signup_path }

    	let(:submit)	{ "Create my account" }

    	describe "with invalid information" do 
    		it "should not create a user" do 
    			expect { click_button submit }.not_to change(User, :count)
    		end
    	end

    	describe "with valid information" do 
    		before do 
    			fill_in "First name",					with: "Example"
    			fill_in "Last name",					with: "User"
    			fill_in "Email",						with: "user@example.com"
    			fill_in "School",						with: "Example High School"
    			fill_in "Password",						with: "password"
    			fill_in "Confirmation",					with: "password"
    		end

    		it "should create user" do 
    			expect { click_button submit }.to change(User, :count).by(1)
    		end

            describe "after saving the user" do 
                before      { click_button submit }
                let(:user)  { User.find_by(email: 'user@example.com') }

                it { should have_link('Sign out') }
                it { should have_title("#{user.first_name} #{user.last_name}") }
                it { should have_selector('div.alert.alert-success', text: "Welcome to STE(A)M Truck!") }
            end
    	end
    end

    describe "edit" do 
        let(:user)  { FactoryGirl.create(:user) }
        before do 
            sign_in user
            visit edit_user_path(user)
        end

        describe "page" do 
            it { should have_content("Update your profile") }
            it { should have_title('Edit user') }
        end

        describe "with invalid information" do 
            before { click_button "Save changes" }

            it { should have_content('error') }
        end

        describe "with valid information" do 
            let(:new_first_name)    { "New" }
            let(:new_last_name)     { "Name" }
            let(:new_name)          { "New Name"}
            let(:new_email)         { "new@example.com" }
            before do 
                fill_in "First name",           with: new_first_name
                fill_in "Last name",            with: new_last_name
                fill_in "Email",                with: new_email
                fill_in "Password",             with: user.password
                fill_in "Confirm Password",      with: user.password
                click_button "Save changes"
            end

            it { should have_title(new_name) }
            it { should have_selector('div.alert.alert-success') }
            it { should have_link('Sign out', href: signout_path) }
            specify { expect(user.reload.first_name).to eq new_first_name }
            specify { expect(user.reload.last_name).to eq new_last_name }
            specify { expect(user.reload.email).to eq new_email }
        end

        describe "forbidden attributes" do 
            let(:params) do 
                { user: { admin: true, password: user.password,
                            password_confirmation: user.password } }
            end
            before do 
                sign_in user, no_capybara: true
                patch user_path(user), params 
            end
            specify { expect(user.reload).not_to be_admin }
        end
    end
end
