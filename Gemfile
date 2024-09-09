# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'zeitwerk'
gem 'bundle-audit'
gem 'bcrypt'
gem 'sinatra', '~>2.2.3'
gem 'sinatra-contrib'
gem 'multi_json'
gem 'oj'
gem 'sequel'

# Dry
gem 'dry-configurable', '~>0.13.0'
gem 'dry-view', '=0.7.1'
gem 'dry-validation'
gem 'dry-struct'
gem 'dry-types'
gem 'dry-monads'
gem 'dry-initializer'

gem 'slim'
gem 'puma', '~>5.6.7'
gem 'rack', '~>2.2.8'
gem 'racksh'
gem 'thor'
gem 'pg'
gem 'mysql2'
gem 'nokogiri', '~>1.16.5'

group :development, :test do
  gem 'rexml', '~>3.3.6' # for rubocop, audited dep
  gem 'rubocop'
  gem 'rubocop-sequel'
  gem 'rubocop-rspec'
  gem 'rubocop-performance'
  gem 'reek'
end

group :test do
  gem 'rspec'
  gem 'fakeweb'
  gem 'database_cleaner-sequel'
end
