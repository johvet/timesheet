require 'spec_helper'
require 'devise/test_helpers'
describe "Customers" do
  describe "GET /customers" do
    it "works! (now write some real specs)" do
      user = FactoryGirl.create(:user)
      visit new_user_session_path
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      click_button "Sign in"

      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit customers_path
      page.should have_content('Listing Customers')
    end
  end
end
