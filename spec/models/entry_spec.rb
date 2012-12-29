require 'spec_helper'

describe Entry do
  context "entry state" do
    it "should report an entry w/o a ticker as not active" do
      entry = Entry.new({duration: 15, ticker_start_at: nil, ticker_end_at: nil})
      entry.should_not be_active
    end

    it "should report an entry with a ticker as active" do
      entry = Entry.new({duration: 15, ticker_start_at: 1.minute.ago, ticker_end_at: nil})
      entry.should be_active
    end
  end

  context "total_duration" do
    before :each do
      @customer = FactoryGirl.create(:customer)
      @user = @customer.user
      @project = FactoryGirl.create(:project, customer: @customer, user: @user)
      @activity = FactoryGirl.create(:activity, user: @user)
    end

    it "should properly report total_duration without a ticker" do
      entry = FactoryGirl.create(:entry, duration: 150, user: @user, project: @project, activity: @activity)
      entry.total_duration.should == 150
    end

    it "should properly report total_duration with a ticker" do
      entry = FactoryGirl.build(:entry, duration: 150, user: @user, project: @project, activity: @activity)
      entry.ticker_start_at = 5.minutes.ago
      entry.total_duration.should == 450
    end

    it "should update total_time and clear ticker upon save" do
      entry = FactoryGirl.build(:entry, duration: 150, user: @user, project: @project, activity: @activity)
      entry.ticker_start_at = 5.minutes.ago
      entry.ticker_end_at = Time.zone.now
      entry.save

      entry.duration.should eq(450)
      entry.ticker_start_at.should be_nil
      entry.ticker_end_at.should be_nil
    end
  end
end
