# frozen_string_literal: true

class Cocktail < ApplicationRecord
  has_ancestry
  has_one :recipe, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  alias twists descendants
end
