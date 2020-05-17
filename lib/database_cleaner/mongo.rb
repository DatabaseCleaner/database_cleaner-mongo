require 'database_cleaner/mongo/version'
require 'database_cleaner/core'
require 'database_cleaner/mongo/deletion'

DatabaseCleaner[:mongo].strategy = :deletion
