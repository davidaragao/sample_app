require 'spec_helper'

describe "Users" do
  
  describe "signup" do

      before { visit signup_path }

      let(:submit) { "Create my account" }

      describe "with invalid information" do
        before do
          fill_in "Name",         with: ""
          fill_in "Email",        with: ""
          fill_in "Password",     with: ""
          fill_in "Confirmation", with: ""
        end
        
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
          response.should render_template('users/new')
          response.should have_selector('div#error_explanation')
        end
      end

      describe "with valid information" do
        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
        end

        it "should create a user" do
          expect { click_button submit }.to change(User, :count).by(1)
          response.should have_selector('div.alert-success', content: "Welcome")
          response.should render_template('users/show')
          controller.should be_signed_in
        end
      end
      
      describe "Sign in" do
        
        describe "Failure" do
          it "Should not sign in user" do
            visit signin_path
            fill_in "Email",    with:""
            fill_in "Password", with:""
            click_button "Sign in"
            response.should have_selector('div.alert-error', content: "Invalid")
            response.should render_template("sessions/new")
          end
        end
        
        describe "Success" do
          let(:user) { FactoryGirl.create(:user) }
          it "Should sign a user in and out" do
            visit signin_path
            fill_in "Email",    with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
            controller.should be_signed_in
            
            # Missing the dropdown signout test 
            #click_link "account"
            #clck_link "signout"
            
            #page.find(:xpath, "//a[@href='signout']").click
            #controller.should_not be_signed_in
          end
        end
        
      end
  end
    
end
