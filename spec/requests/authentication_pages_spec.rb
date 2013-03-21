require 'spec_helper'

describe "Authentication" do

  subject { page }

  # Check elements in login page
  describe "login page" do
    before { visit login_path }

    it { should have_selector('h1',    text: 'Log in') }
    it { should have_selector('title', text: 'Log in') }
  end

  # Test logging in process
  describe "login" do
    before { visit login_path }

    # Inputted data is invalid
    describe "with invalid information" do
      before { click_button "Log in" }

      it { should have_selector('title', text: 'Log in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      
      # Check that error message doesn't persist tp other pages
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

    end
  
  	# Inputted data is valid
	  describe "with valid information" do
	  		# Create user
	      let(:user) { FactoryGirl.create(:user) }
	      # Fill & submit login form
	      before do
	      	# Make email upper case to make sure our database is case-insensitive
	        fill_in "Email",    with: user.email.upcase
	        fill_in "Password", with: user.password
	        click_button "Log in"
	      end

	      it { should have_selector('title', text: user.name) }
	      it { should have_link('Profile', href: user_path(user)) }
	      it { should have_link('Log out', href: logout_path) }
	      it { should_not have_link('Log in', href: login_path) }
	      
	      # Test logging out
	      describe "followed by logout" do
	        before { click_link "Log out" }
	        it { should have_link('Log in') }
	      end
    end

  end

end
