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

  context "with a list of valid entries" do
    before :each do
      @customer = FactoryGirl.create(:customer, user: @user)
      @project = FactoryGirl.create(:project, user: @user, customer: @customer)
      @activity = FactoryGirl.create(:activity, user: @user)
      @entry = FactoryGirl.create(:entry, user: @user, project: @project, activity: @activity, duration: 150)
    end

    it "should show a list of entries for the current day" do
      old = FactoryGirl.create(:entry, user: @user, project: @project, activity: @activity, executed_on: 1.day.ago)
      visit entries_path
      page.should have_content(@entry.project.title)
    end

    it "should show a ticking timer for a started entry" do
      visit entries_path
      page.should have_css("span.ticker[@data-id='#{@entry.id}']")
    end

    it "should start ticking the timer", :js => true do
      visit entries_path
      page.find("#entry_#{@entry.id} .toggle").click
      page.should have_css('.ticker.ticking')
    end

    it "should stop a ticking entry", :js => true do
      @entry.ticker_start_at = 5.minutes.ago
      @entry.save
      visit entries_path
      page.find("#entry_#{@entry.id} .toggle").click
      page.should have_no_css('.ticker.ticking')
    end

    it "should create a new entry", :js => true do
      before = Entry.count
      visit new_entry_path()
      select(@project.title, from: 'Project')
      select(@activity.name, from: 'Activity')
      fill_in "Duration", with: "00:10:00"
      click_on "Create Entry"

      Entry.count.should eql(before + 1)
      page.should have_content("Entry was successfully created")
      rec = Entry.last
      rec.duration.should eql(600)
      rec.project.should eql(@project)
      rec.activity.should eql(@activity)
    end

  end

end
