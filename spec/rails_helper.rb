# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?
return unless Rails.env.test?

require 'rspec/rails'
require 'rake'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    Rake.application = Rake::Application.new
    Rails.application.load_tasks
  end

  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end
