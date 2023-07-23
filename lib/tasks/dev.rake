# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
if Rails.env.development? || Rails.env.test?
  # Q: Why need a class here?
  # A: not to expose the methods in rake
  # ref: https://supergood.software/dont-step-on-a-rake/
  class CreateLocalEnvironmentTasks
    require 'factory_bot'

    include Rake::DSL
    include FactoryBot::Syntax::Methods

    def initialize
      namespace :dev do
        desc 'Sample data for local development environment'
        # TODO: also need to flush Redis data after implementing redis
        task prime: %w[
          db:drop
          db:setup
        ] do
          create(:user, :admin, name: '德民', email: 'admin@hahow.in', password: 'password1234')
          create(:user, name: '油蛇', email: 'user@hahow.in', password: 'password1234')

          create_ingredirents
        end
      end
    end

    private

    def create_ingredirents
      create(:ingredient, name: 'Gin')
      create(:ingredient, name: 'Rum')
      create(:ingredient, name: 'Vodka')
      create(:ingredient, name: 'Whisky')
      create(:ingredient, name: 'Tequila')
      create(:ingredient, name: 'Brandy')
    end
  end

  CreateLocalEnvironmentTasks.new
end
# rubocop:enable Metrics/MethodLength
