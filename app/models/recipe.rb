# frozen_string_literal: true

class Recipe < ApplicationRecord
  include AASM

  belongs_to :cocktail
  belongs_to :glass
  has_many :steps, dependent: :destroy
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  has_one_attached :cover_image

  validates :publish_state, presence: true

  aasm :publish_state, column: :publish_state do
    state :draft, initial: true
    state :published
    state :unpublished

    after_all_transitions :set_published_at

    event :publish do
      transitions from: %i[draft unpublished], to: :published
    end

    event :unpublish do
      transitions from: :published, to: :unpublished
    end
  end

  private

  def set_published_at
    self.published_at = aasm(:publish_state).to_state == :published ? DateTime.current : nil
  end
end
