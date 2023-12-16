class Local::Provider < ApplicationRecord
  validates :ukprn, presence: true, uniqueness: true
end
