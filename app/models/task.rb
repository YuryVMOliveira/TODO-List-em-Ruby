class Task < ApplicationRecord
  belongs_to :user
  belongs_to :list
  validates :title, presence: true
end
