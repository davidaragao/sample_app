require 'spec_helper'

describe PagesController do
  render_views
  
  before(:each) do
    @basetitle = "Ruby on Rails Tutorial Sample App"
  end
  
  subject { response }
  
  describe "Home Page" do
    before{ get 'home' }
    it { should be_success }
    it { should have_selector("title", :content => "#{@basetitle} | Home") }
    it { body.should_not =~ /<body>\s*<\/body>/ }  
  end

  describe "Contact Page" do
    before{ get 'contact' }
    it { should be_success }
    it { should have_selector("title", :content => "#{@basetitle} | Contact") }
    it { body.should_not  =~ /<body>\s*<\/body>/ }
  end
  
  describe "About Page" do
    before{ get 'about' }
    it { should be_success }
    it { should have_selector("title", :content => "#{@basetitle} | About") }
    it { body.should_not  =~ /<body>\s*<\/body>/ }
  end
  
  describe "Contact Help" do
    before{ get 'help' }
    it { should be_success }
    it { should have_selector("title", :content => "#{@basetitle} | Help") }
    it { body.should_not  =~ /<body>\s*<\/body>/ }
  end
end
