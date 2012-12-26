require 'spec_helper'

describe "Entries" do
  before :each do
    @user = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_on "Sign in"
  end

  it "should have a link in the main navigation" do
    visit root_path
    page.has_link?("ul.nav li a", :href => entries_path)
  end

  it "should show a list of entries for the current day" do
    customer = FactoryGirl.create(:customer, user: @user)
    project = FactoryGirl.create(:project, user: @user, customer: customer)
    activity = FactoryGirl.create(:activity, user: @user)

    entry = FactoryGirl.create(:entry, user: @user, project: project, activity: activity)
    old = FactoryGirl.create(:entry, user: @user, project: project, activity: activity, executed_on: 1.day.ago)
    visit entries_path
    page.should have_content(entry.project.title)
  end
end
