require 'database_cleaner/mongo/version'
require 'database_cleaner/core'
require 'database_cleaner/mongo/truncation'

DatabaseCleaner[:mongo].strategy = :truncation
