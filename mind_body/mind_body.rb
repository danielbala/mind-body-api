require 'savon'
require "active_support"

Savon.configure do |config|
  config.log_level = :debug
  config.logger = Rails.logger
  config.raise_errors = false
end

Dir[File.dirname(__FILE__) + '/**/*.rb'].each {|file| require file }
