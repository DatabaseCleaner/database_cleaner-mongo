require 'database_cleaner/strategy'
require 'mongo'

module DatabaseCleaner
  module Mongo
    class Truncation < Strategy
      def initialize only: [], except: []
        @only = only
        @except = except
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
