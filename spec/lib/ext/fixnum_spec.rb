require 'spec_helper'

describe "Fixnum" do

  it "should properly convert seconds to time-strings" do
    {15 => "00:00:15", 60 => "00:01:00", 119 => "00:01:59", 6307 => "01:45:07"}.each do |value, result|
      value.to_time.should == result
    end
  end

end