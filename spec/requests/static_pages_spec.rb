require 'spec_helper'

describe "StaticPages" do

	let(:base_title) 	{ "STE(A)M Truck™"}
  
  describe "Homepage" do 

  	it "should have the content 'STE(A)M Truck'" do 
  		visit '/static_pages/home'
  		expect(page).to have_content('STE(A)M Truck')

    end

    it "should have the right title 'Home'" do 
    	visit '/static_pages/home'
    	expect(page).to have_title("#{base_title}")
    end

    it "should not have a custom page title" do 
    	visit '/static_pages/home'
    	expect(page).not_to have_title('| Home')
    end
  end

  describe "Help page" do 

  	it "should have content 'Help'" do
  		visit '/static_pages/help'
  		expect(page).to have_content('Help')
  	end

  	it "should have the right title'Help'" do 
  		visit '/static_pages/help'
  		expect(page).to have_title("#{base_title}| Help")
  	end
  end

  describe "About page" do 

  	it "should have content 'About'" do
  		visit '/static_pages/about'
  		expect(page).to have_content('About')
  	end

  	it "should have the right title 'About'" do 
  		visit '/static_pages/about'
  		expect(page).to have_title("#{base_title}| About")
  	end
  end

  describe "Contact page" do 

  	it "should have content 'Contact'"  do 
  		visit '/static_pages/contact'
  		expect(page).to have_content('Contact')
  	end

  	it "should have the right title 'Contact'" do 
  		visit '/static_pages/contact'
  		expect(page).to have_title("#{base_title}| Contact")
  	end
  end
end
