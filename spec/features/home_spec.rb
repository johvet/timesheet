require 'spec_helper'

describe 'home page' do
  it 'welcomes the user' do
    visit '/'
    page.should have_content('Welcome')
  end

  context "as a guest user" do
    it "should contain a sign in form in the main navigation bar" do
      visit '/'
      page.should have_css('.navbar-form')
    end
  end
end