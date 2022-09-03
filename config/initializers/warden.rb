# frozen_string_literal: true

Warden::Strategies.add(:password, Authentication::PasswordStrategy)
