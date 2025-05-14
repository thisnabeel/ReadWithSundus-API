class UserAvailability < ApplicationRecord
  belongs_to :user

  validates :day, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :timezone, presence: true
end
