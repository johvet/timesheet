require 'spec_helper'

describe ActiveRecord::Base do
  class Sample < ActiveRecord::Base; end

  it "#flash_message" do
    Sample.model_name.should eql('Sample')
    Sample.flash_message(:create).should eql('Sample was successfully created.')
  end

end