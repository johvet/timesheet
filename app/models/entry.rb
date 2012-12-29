class Entry < ActiveRecord::Base
  attr_accessible :activity_id, :description, :duration, :project_id, :executed_on, :ticker_start_at, :ticker_end_at, :user_id, :string_duration

  belongs_to :user
  belongs_to :project
  belongs_to :activity

  validates_presence_of :user, :project, :activity, :executed_on

  before_validation :ensure_user_matches
  before_save :track_current_ticker

  def total_duration
    result = self.duration
    if self.ticker_start_at.present?
      start, stop = [ticker_start_at, ticker_end_at || Time.zone.now].sort
      result += (stop - start).to_i
    end
    result
  end

  def string_duration
    self.duration.to_time rescue 0.to_time
  end

  def string_duration=(value)
    self.duration = value.from_time
  end

  def active?
    self.ticker_start_at.present?
  end

  private

  def ensure_user_matches
    if self.user_id
      self.errors.add(:project, :mismatch) unless self.project.try(:user_id) == self.user_id
      self.errors.add(:activity, :mismatch) unless self.activity.try(:user_id) == self.user_id
    end
  end

  def track_current_ticker
    if ticker_start_at.present? and ticker_end_at.present?
      start_time, end_time = [ticker_start_at, ticker_end_at].sort
      self.duration += (end_time - start_time)
      self.ticker_start_at = self.ticker_end_at = nil
    end
  end
end
