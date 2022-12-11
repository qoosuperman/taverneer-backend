# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  PASSWORD_FORMAT = /
    \A
    (?=.*?\d)           # Must contain a digit
    (?=.*?[a-zA-Z])     # Must contain a character
    .{8,}               # Must contain at least 8 characters
    \z
  /x.freeze

  validates :name, presence: true
  validates :password, format: { with: PASSWORD_FORMAT, message: :malformed_password },
                       unless: proc { |user| user.password.nil? }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  def admin?
    is_admin == true
  end
end
