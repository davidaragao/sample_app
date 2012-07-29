require 'spec_helper'
require 'support/utilities'

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
        # Method from spec/support/utilities 
        sign_in(user)
      end
      
      it "Should sign the user in" do
        controller.current_user.should == user
        controller.should be_signed_in
      end
      
      # it "redirect to the user show page" do
      #         response.should redirect_to user
      #       end
                      
      it { should have_selector('title', content: user.name) }
      it { should have_selector('a', href: users_path, content: "Users")}
      it { should have_selector('a', href: user_path(user), content: "Profile") }
      it { should have_selector('a', href: signout_path, content: "Sign out") }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end
  
  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            response.should have_selector('title', content: 'Edit user')
          end
        end
      end
      
      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', content: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          it { should redirect_to(signin_path) }
        end
        
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', content: 'Sign in') }
        end
      end
    end
    
    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', content: 'Edit user') }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        it { should redirect_to(root_path) }
      end
    end
    
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end  
  
end