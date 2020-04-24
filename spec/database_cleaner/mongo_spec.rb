require 'database_cleaner/mongo'
require 'database_cleaner/spec'

RSpec.describe DatabaseCleaner::Mongo do
  it_should_behave_like "a database_cleaner adapter"
end

