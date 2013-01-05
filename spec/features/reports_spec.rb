require 'spec_helper'

describe 'Reports' do
  context "as guest" do
    it "should redirect a guest to the new_user_session_path" do
      visit reports_path
      current_path.should == new_user_session_path
    end
  end

  context "as signed in user" do
    before do
      @user = FactoryGirl.create(:user)
      visit new_user_session_path
      fill_in "Email", :with => @user.email
      fill_in "Password", :with => @user.password
      click_on "Sign in"

      @customers = []
      %w(Foo Bar).each do |name|
        @customers << FactoryGirl.create(:customer, name: name, user: @user)
      end
      other_user = FactoryGirl.create(:user, email: "other@example.com")
      other_customer = FactoryGirl.create(:customer, name: "Somebody else", user: other_user)

      @projects = []
      %w(Very Tricky Things).each do |name|
        @projects << FactoryGirl.create(:project, title: name, user: @user, customer: @customers.first)
      end
    end

    context "the filter form" do
      it "should contain the proper list of filter selects" do
        visit reports_path
        all('#filter_period option').length.should == 33
        find('#filter_customer').should have_content('All' + @customers.map(&:name).sort.join(''))
        find('#filter_project').should have_content('All' + @projects.map(&:title).sort.join(''))
        find('#filter_chargeable').should have_content('AllYesNo')
      end
    end

  end
end