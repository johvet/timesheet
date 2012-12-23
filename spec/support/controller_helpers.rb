module ControllerHelpers
  def sign_in(user = FactoryGirl.create('user'))
    raise "ANOTHER EXCEPTION"
    if user.nil?
      puts "no way, this is not signed in"
      request.env['warden'].stub(:authenticate!).
        and_throw(:warden, {:scope => :user})
      controller.stub :current_user => nil
    else
      puts "signing in this guy!"
      request.env['warden'].stub :authenticate! => user
      controller.stub :current_user => user
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include ControllerHelpers, :type => :controller
end