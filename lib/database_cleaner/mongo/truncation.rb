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
        if @only.any?
          collections.each { |c| c.delete_many if @only.include?(c.name) }
        else
          collections.each { |c| c.delete_many unless @except.include?(c.name) }
        end
        true
      end

      private

      def database
        db
      end

      def collections
        database.collections.select { |c| c.name !~ /^system\./ }
      end
    end
  end
end
