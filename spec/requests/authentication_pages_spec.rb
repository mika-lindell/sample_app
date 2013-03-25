require 'spec_helper'

# Test related for user authentication

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
	      
        it { should have_link('Users',    href: users_path) }
        it { should have_link('Profile', href: user_path(user)) }
	      it { should have_link('Settings', href: edit_user_path(user)) }
        it { should have_link('Log out', href: logout_path) }
	      
        it { should_not have_link('Log in', href: login_path) }
	      
	      # Test logging out
	      describe "followed by logout" do
	        before { click_link "Log out" }
	        it { should have_link('Log in') }
          it { should_not have_link('Settings', href: edit_user_path(user)) }
	      end
    end

  end

  describe "authorization" do

    describe "for logged-in users" do

      let(:user) { FactoryGirl.create(:user) }
      before { log_in user }

      describe "in the Users controller" do

        describe "submitting to view the new page" do
          before { get new_user_path }
          # With using http request methods directly, one must use response-object instead page-object
          specify { response.should redirect_to(user) }
        end

        describe "submitting to the create action" do
          before { post users_path(user) }
          # With using http request methods directly, one must use response-object instead page-object
          specify { response.should redirect_to(user) }
        end
      end

    end

    describe "for non-logged-in users" do
      
      it { should_not have_link('Users',    href: users_path) }
      it { should_not have_link('Profile', href: user_path(user)) }
      it { should_not have_link('Settings', href: edit_user_path(user)) }
      it { should_not have_link('Log out', href: logout_path) }

      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Log in') }
        end

        describe "submitting to the update action" do
          # Here we use put to make request with http PUT-method. If we use visit, we get action create, with put it's update
          before { put user_path(user) }
          # With using http request methods directly, one must use response-object instead page-object
          specify { response.should redirect_to(login_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Log in') }
        end

      end

      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(login_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(login_path) }
        end
      end

      # Friendly forwarding
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Log in"
        end

        describe "after logging in" do

          it "should render the desired protected page" do
            should have_selector('title', text: 'Edit user')
          end

          describe "when logging in again" do
            before do
              delete logout_path
              visit login_path
              log_in user
            end

            it "should render the default (profile) page" do
              should have_selector('title', text: user.name) 
            end
          end
        end
      end

    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { log_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { log_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { log_in admin }

      describe "submitting a DELETE request to self" do
        before { delete user_path(admin) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end

end
