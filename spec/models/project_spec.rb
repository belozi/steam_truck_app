require 'spec_helper'

describe Project do

  let(:user)  { FactoryGirl.create(:user) }
  before { @project = user.projects.build(project_title: "Middle School Project",
  							description: "At the Middle School solving problems",
  							problem: "How do we reach these kids?",
  							solution: "Let them learn by playing",
  							status: "In effect") }

  subject { @project }

  it { should respond_to(:project_title) }
  it { should respond_to(:user_id) }
  it { should respond_to(:description) }
  it { should respond_to(:problem) }
  it { should respond_to(:solution) }
  it { should respond_to(:status) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do 
  	before { @project.user_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank title" do 
  	before { @project.project_title = " " }
  	it { should_not be_valid }
  end

  describe "with title that is too long" do 
  	before { @project.project_title = "x" * 91}
  	it {should_not be_valid }
  end

    describe "with blank description" do 
  	before { @project.description = " " }
  	it { should_not be_valid }
  end

  describe "with description that is too long" do 
  	before { @project.description = "x" * 801}
  	it {should_not be_valid }
  end

    describe "with blank problem" do 
  	before { @project.problem = " " }
  	it { should_not be_valid }
  end

  describe "with problem that is too long" do 
  	before { @project.problem = "x" * 301}
  	it {should_not be_valid }
  end

    describe "with blank solution" do 
  	before { @project.solution = " " }
  	it { should_not be_valid }
  end

  describe "with title that is too long" do 
  	before { @project.solution = "x" * 301}
  	it {should_not be_valid }
  end

    describe "with blank status" do 
  	before { @project.status = " " }
  	it { should_not be_valid }
  end

  describe "with status that is too long" do 
  	before { @project.status = "x" * 101}
  	it {should_not be_valid }
  end

  describe "project index page" do
  	let(:user)	{FactoryGirl.create(:user) }
  	let!(:p1)	{ FactoryGirl.create(:project, user: user
  										project_title: "Middle School Project",
  										description: "Middle School Students finding techical solutions to problems in the classroom",
  										problem: "The world needs answers",
  										solution: "Give them answers",
  										status: "In effect") }
  	let!(:p2)	{ FactoryGirl.create(:project, user: user
  										project_title: "Elementary School Project",
  										description: "Elementary School Students finding techical solutions to problems in the classroom",
  										problem: "The world needs answers",
  										solution: "Give them answers",
  										status: "In effect") }

  	before { visit projects_path }

  	it { should have_title("STE(A)M™ Truck Projects") }

  	describe "projects" do  
  		it { should have_description(p1.description) }
  		it { should have_description(p2.description) }
  	end
  end

end

