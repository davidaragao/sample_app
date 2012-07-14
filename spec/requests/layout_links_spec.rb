require 'spec_helper'

describe "LayoutLinks" do
  
  it "Should have home page at '/'" do 
    get '/'
    response.should have_selector('title', :content => "Home")
  end
  
  it "Should have contact page at '/contact'" do 
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end
  
  it "Should have about page at '/about'" do 
    get '/about'
    response.should have_selector('title', :content => "About")
  end
  
  it "Should have help page at '/help'" do 
    get '/help'
    response.should have_selector('title', :content => "Help")
  end
  
  it "Should have sign up page at '/signup'" do 
    get '/signup'
    response.should have_selector('h1', :content => "Sign up")
    response.should have_selector('title', :content => "Sign up")
  end
  
  it "It Should have the right links on the layout" do 
    visit root_path
    response.should have_selector('title', :content => "Home")
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Home"
    response.should have_selector('title', :content => "Home")
    click_link "Sign up now!"
    response.should have_selector('title', :content => "Sign up")
  end
  
  describe "profile page" do
      subject { response }
      let(:user) { FactoryGirl.create(:user) }
      before { visit user_path(user) }

      it { should have_selector('h1',    content: user.name) }
      it { should have_selector('title', content: user.name) }
  end
      
end
