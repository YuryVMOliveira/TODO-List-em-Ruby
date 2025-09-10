class List < ApplicationRecord
  belongs_to :user
  has_many :tasks

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
