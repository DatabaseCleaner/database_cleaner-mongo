require 'database_cleaner/strategy'
require 'database_cleaner/deprecation'
require 'mongo'

module DatabaseCleaner
  module Mongo
    class Truncation < Strategy
      def initialize only: [], except: [], cache_tables: nil
        @only = only
        @except = except
        if !cache_tables.nil?
          DatabaseCleaner.deprecate "The mongo adapter's :cache_tables option has no effect, and will be removed in database_cleaner-mongo 3.0."
        end
      end

      def db
        @db || raise("You have not specified a database.  (see Mongo::Database)")
      end

      def clean
        collections_to_delete.each(&:delete_many)
      end

      private

      def collections_to_delete
        collections.select do |c|
          (@only.none? || @only.include?(c.name)) && !@except.include?(c.name)
        end
      end

      def collections
        db.collections.select { |c| c.name !~ /^system\./ }
      end
    end
  end
end
