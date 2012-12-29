require 'spec_helper'

describe "String" do

  it "should properly convert time-strings to seconds" do
    {
      "00:00:15" => 15, "00:01:00" => 60, "00:01:59" => 119, "01:45:07" => 6307, "01:01:01:01" => 90061}.each do |value, result|
      value.from_time.should == result
    end
  end

end