require 'spec_helper'

describe User do
  
  before 	{ @user = User.new(first_name: "Example", last_name: "User", 
  					email: "user@example.com", school: "Example High School",
            password: "foobar", password_confirmation: "foobar") }

  subject	{ @user  }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:school) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:posts) }
  it { should respond_to(:projects) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do 
    before do 
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end


  describe "when first_name is not present" do 
  	before 	{ @user.first_name = "" }
  	it 		{ should_not be_valid }
  end

  describe "when last_name is not present" do 
  	before	{ @user.last_name = "" }
  	it		{ should_not be_valid }
  end

  describe "when email is not present" do 
  	before	{ @user.email = "" }
  	it 		{ should_not be_valid }
  end

  describe "when school is not presnt" do 
  	before	{ @user.school = "" }
  	it		{ should_not be_valid }
  end

  describe "when first_name is too long" do 
  	before	{ @user.first_name = "x" * 31 }
  	it 		{ should_not be_valid }
  end

  describe "when last_name is too long" do 
  	before	{ @user.last_name = "o" * 31 }
  	it		{ should_not be_valid }
  end

  describe "when the email format is valid" do 
  	it "should be valid" do 
  		addresses = %w[user@foo.COM A_US-ER@f.b.org 
                        frst.lst@foo.jp a+b@baz.cn]
  		addresses.each do |valid_address|
  			@user.email = valid_address
  			expect(@user).to be_valid
  		end
  	end
  end

  describe "when email format is invalid" do 
  	it "should be invalid" do 
  		addresses = %w[user@foo,com user_at_foo.org example.user@foo. 
  							foo@bar_baz.com foo@bar+baz.com foo@bar..com]
  		addresses.each do |invalid_address|
  			@user.email = invalid_address
  			expect(@user).not_to be_valid
  		end
  	end
  end

  describe "email address with mixed case" do 
    let(:mixed_case_email)  { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do 
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when email address is already taken" do 
  	before do 
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	end

  	it { should_not be_valid }
  end

  describe "when password is not present" do 
    before do 
      @user = User.new(first_name: "Example", last_name: "User", email: "user@example.com",
                            school: "Example High School", password: " ",
                             password_confirmation: " " )
    end

    it     { should_not be_valid }
  end

  describe "when password doesn't match contribution" do 
    before { @user.password_confirmation = "mismatch" }
    it     { should_not be_valid }
  end

  describe "with a password that is too short" do 
    before { @user.password = @user.password_confirmation = "x" * 5 }
    it     { should be_invalid }
  end

  describe "return value of authenticate method" do 
    before { @user.save }
    let(:found_user)  { User.find_by(email: @user.email) }

    describe "with valid password" do 
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do 
      let(:user_for_invalid_password)   { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "remember_token" do 
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "post associations" do 

    before { @user.save }
    let!(:older_post) do 
      FactoryGirl.create(:post, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_post) do
      FactoryGirl.create(:post, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right posts in the right order" do 
      expect(@user.posts.to_a).to eq [newer_post, older_post]
    end

    it "should destroy associated posts" do 
      posts = @user.posts.to_a
      @user.destroy
      expect(posts).not_to be_empty
      posts.each do |post|
        expect(Post.where(id: post.id)).to be_empty
      end
    end

    describe "status" do 
      let(:unfollowed_post) do 
        FactoryGirl.create(:post, user: FactoryGirl.create(:user))
      end
      let(:followed_user)   { FactoryGirl.create(:user) }

      before do 
        @user.follow!(followed_user)
        3.times { followed_user.posts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_post) }
      its(:feed) { should include(older_post) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do 
        followed_user.posts.each do |post|
          should include(post)
        end
      end
    end
  end

  describe "project associations" do 

    before { @user.save }
    let!(:older_project) do 
      FactoryGirl.create(:project, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_project) do 
      FactoryGirl.create(:project, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right projects in the right order" do 
      expect(@user.projects.to_a).to eq [newer_project, older_project]
    end
  end

  describe "following" do 
    let(:other_user)  { FactoryGirl.create(:user) }
    before do 
      @user.save
      @user.follow!(other_user)
    end

    it                    { should be_following(other_user) }
    its(:followed_users)  { should include(other_user)}

    describe "followed user" do 
      subject         { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do 
      before { @user.unfollow!(other_user) }

      it                    { should_not be_following(other_user) }
      its(:followed_users)  { should_not include(other_user) }
    end
  end
end
