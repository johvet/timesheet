require 'spec_helper'

describe 'Activities' do
  context "As a logged in User" do
    before :each do
      @user = FactoryGirl.create(:user, email: "foo@bar.com")
      visit new_user_session_path
      fill_in "Email", :with => @user.email
      fill_in "Password", :with => @user.password
      click_on "Sign in"
    end

    it "should show a link to the activities in the main navigation" do
      visit root_url
      page.has_link?("ul.nav li a", :href => activities_path)
    end

    it "should show a list of activities" do
      items = %w(Development Bugfixing)
      items.each do |name|
        FactoryGirl.create(:activity, name: name, user: @user)
      end
      visit activities_path
      items.each do |name|
        page.should have_content(name)
      end
    end

    it "should show a form to add a new acitvity" do
      visit new_activity_path
      page.has_css?('form#new_activity_form')
    end

    it "should create a new activity" do
      name = "Some Activity"
      visit new_activity_path
      fill_in "Name", :with => name
      click_on "Save"
      page.should have_content("successfully created")
      @user.activities(true).last.name == name
    end

    it "should show an error if no name is given" do
      visit new_activity_path
      click_on "Save"
      page.should have_content("Name can't be blank")
    end

    it "should show an error if trying to add a duplicate" do
      act = FactoryGirl.create(:activity, user: @user)
      visit new_activity_path
      fill_in "Name", :with => act.name
      click_on "Save"
      page.should have_content("Name has already been taken")
    end

    it "should properly update an activity" do
      act = FactoryGirl.create(:activity, user: @user)
      new_name = "#{act.name} 2"

      visit edit_activity_path(act)
      fill_in "Name", :with => new_name
      click_on "Save"
      page.should have_content("successfully updated")
      act.reload.name.should == new_name
    end

    it "should delete an activity" do
      act = FactoryGirl.create(:activity, user: @user)
      @user.activities(true).count.should == 1

      visit activities_path

      click_on "Destroy"
      @user.activities.count.should == 0
    end
  end
end