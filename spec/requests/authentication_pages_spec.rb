require 'spec_helper'

describe "Authentication" do

  subject { response }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    content: 'Sign in') }
    it { should have_selector('title', content: 'Sign in') }
  end
  
  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', content: 'Sign in') }
      it { should have_selector('div.alert.alert-error', content: 'Invalid') }
      
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
  
    # describe "with valid information" do      
    #       let(:user) { FactoryGirl.create(:user) }
    #       before do
    #         fill_in "Email",    with: user.email
    #         fill_in "Password", with: user.password
    #       end
    #       
    #       before {  click_button "Sign in" }
    # 
    #       it { should have_selector('title', content: user.name) }
    #       it { should have_link('Profile', href: user_path(user)) }
    #       it { should have_link('Sign out', href: signout_path) }
    #       it { should_not have_link('Sign in', href: signin_path) }
    #     end
  end
end