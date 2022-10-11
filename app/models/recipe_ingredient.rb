# frozen_string_literal: true

class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  validates :amount, presence: true
  validate :validate_amount_format
  validates :ingredient_id, uniqueness: { scope: :recipe_id }

  private

  def validate_amount_format
    return if /^\d+ \w+$/.match?(amount)
    return if amount == '適量'

    errors.add(:amount, I18n.t('activerecord.errors.messages.exceed_max_authorized_users'))
  end
end
