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
end
