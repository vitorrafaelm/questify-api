class Theme < ApplicationRecord
  include Discard::Model

  # Associations
  has_and_belongs_to_many :questions

  # Validations
  validates :title, presence: true, uniqueness: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 500 }

  # Scopes
  scope :active, -> { kept }
end