# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/safe_migrations'
require_relative 'rubocop/safe_migrations/version'
require_relative 'rubocop/safe_migrations/inject'

RuboCop::SafeMigrations::Inject.defaults!

require_relative 'rubocop/cop/safe_migrations_cops'
