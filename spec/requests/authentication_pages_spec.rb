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
      it { should_not have_link('Sign in', href: signin_path) }
      
      
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
      
      # describe "followed by signout" do
      #        before { click_link "Sign out" }
      #        it { should have_link('Sign in') }
      #      end
      
    end
  
    
    describe "with valid information" do      
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      
      it "Should sign the user in" do
        controller.current_user.should == user
        controller.should be_signed_in
      end
      
      # it "redirect to the user show page" do
      #         response.should redirect_to user
      #       end
                      
      it { should have_selector('title', content: user.name) }
      it { should have_selector('a', href: user_path(user), content: "Profile") }
      it { should have_selector('a', href: signout_path, content: "Sign out") }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end
  
  
end