# frozen_string_literal: true

class CreatePublishStateEnum < ActiveRecord::Migration[6.0]
  def change
    create_enum :publish_state, %w[draft published unpublished]
  end
end
