require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:wrong_user) { FactoryGirl.create(:user) }

  before { log_in user }

  describe "pagination" do

      before(:all) do 
        35.times { FactoryGirl.create(:micropost, user: user) } 
        visit root_path
      end
      after(:all)  { user.microposts.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each micropost for user" do
        user.microposts.paginate(page: 1).each do |micropost|
          page.should have_selector('li', id: micropost.id)
        end
      end
    end


  describe "in user info" do
    before { visit root_path }

    it { should have_link('view my profile', href: user_path(user)) }
    it { should have_content(user.microposts.count)}
  
  end

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before do 
      FactoryGirl.create(:micropost, user: user)
      visit root_path
    end

    describe "as correct user" do
      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

    
    describe "as incorrect user" do
      before do
        FactoryGirl.create(:micropost, user: wrong_user )
        visit user_path(wrong_user)
      end

      it { should_not have_link("delete")} 

    end
  end
  
end
