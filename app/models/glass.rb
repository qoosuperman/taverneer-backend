# frozen_string_literal: true

class Glass < ApplicationRecord
  has_many :recipes, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
end
