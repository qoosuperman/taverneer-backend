# frozen_string_literal: true

class Step < ApplicationRecord
  belongs_to :recipe

  validates :description, :position, presence: true

  # NOTE: 同一個 recipe 每個 step position 需要 unique
  # 但可能上一個 step 正在改 position，下一個 position 還沒改因此重複
  # 所以 db layer 不加上 unique index 只在 model layer 做
  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :position, uniqueness: { scope: :recipe_id }
  # rubocop:enable Rails/UniqueValidationWithoutIndex
end
