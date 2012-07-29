require 'spec_helper'

describe "User Pages" do
  
  describe "signup page" do
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
  end
      
  describe "signin page" do
        
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
  
  describe "profile page" do
    subject { response }
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    content: user.name) }
    it { should have_selector('title', content: user.name) }
  end
  
  describe "edit" do
    subject { response }
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user) 
    end
    
    describe "page" do 
      it { should have_selector('h1',    content: "Update your profile") }
      it { should have_selector('title', content: "Edit user") }
      it { should have_selector('a', href: 'http://gravatar.com/emails', content: "change") }
    end
    
    describe "with invalid information" do
      before { click_button "Save changes" }
      
      it { should have_selector('div.alert-error', content: "error") }
    end
    
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirmation",     with: user.password_confirmation
        click_button "Save changes"
      end

      it { should have_selector('title', content: new_name) }
      it { should have_selector('div.alert.alert-success', content: "Profile updated") }
      it { should have_selector("a", href: signout_path, content: "Sign out") }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
    
  end
  
  describe "index" do
    subject { response }
    let(:user) { FactoryGirl.create(:user) }
    
    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all) { User.delete_all }
    
    before(:each) do
        sign_in user
        visit users_path
    end

    it { should have_selector('title', content: 'All users') }
    it { should have_selector('h1',    content: 'All users') }

    it { should have_selector('div.pagination') } 

    it "should list each user" do
      User.paginate(page:1).each do |user|
        response.should have_selector('li', content: user.name)
      end
    end
  end
        
end
