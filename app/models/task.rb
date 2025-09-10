class Task < ApplicationRecord
    belongs_to :List
    validates :title, presence: true
end
