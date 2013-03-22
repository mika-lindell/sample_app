require 'spec_helper'

describe "User pages" do

  subject { page }

  # Index contents 
  describe "index" do
    
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      log_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        # Create admin user and log in
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          log_in admin
          visit users_path
        end

        # We should be able to delete other users
        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        # We shouldn't to be able to delete ourselves
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  
  end

  # Profile page contents
  describe "profile page" do
	  # Code to make a user variable
	  let(:user) { FactoryGirl.create(:user) }
	  before { visit user_path(user) }

	  it { should have_selector('h1',    text: user.name) }
	  it { should have_selector('title', text: user.name) }
	end
	 
	 # Sign-up page contents
  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  # Signing up action
	describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    # With invalid information
    describe "with invalid information " do
      
    	# Clicking submit should not change database
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      # Clicking submit should display error messages
      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
      end

    end

    # With valid information
    describe "with valid information" do

    	# Fill fields in our signup form
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      # Click submit and it should add user to dabase
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      # After saving user go to profile page and display welcome message
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Log out') }
      end

    end

    # Editing user page
    describe "edit" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        log_in user
        visit edit_user_path(user)
      end

      describe "page" do
        it { should have_selector('h1',    text: "Update your profile") }
        it { should have_selector('title', text: "Edit user") }
        it { should have_link('change', href: 'http://gravatar.com/emails') }
      end

      describe "with invalid information" do
        before { click_button "Save changes" }

        it { should have_content('error') }
      end

      describe "with valid information" do
        let(:new_name)  { "New Name" }
        let(:new_email) { "new@example.com" }
        before do
          fill_in "Name",             with: new_name
          fill_in "Email",            with: new_email
          fill_in "Password",         with: user.password
          fill_in "Confirm Password", with: user.password
          click_button "Save changes"
        end

        it { should have_selector('title', text: new_name) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Log out', href: logout_path) }
        # Reloads values from test db to verify values have changed
        specify { user.reload.name.should  == new_name }
        specify { user.reload.email.should == new_email }
      end

    end

  end

end
