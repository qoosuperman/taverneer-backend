# frozen_string_literal: true

json.ingredients @ingredients do |ingredient|
  json.id ingredient.id
  json.name ingredient.name
end
