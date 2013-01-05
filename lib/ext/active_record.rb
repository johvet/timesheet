class ActiveRecord::Base

  def self.flash_message(action)
    I18n.t(action, scope: [:activerecord, :flash], model: self.model_name.human)
  end
  def flash_message(action)
    self.class.flash_message(action)
  end

end