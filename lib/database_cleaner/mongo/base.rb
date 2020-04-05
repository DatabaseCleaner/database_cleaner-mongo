module DatabaseCleaner
  module Mongo
    def self.available_strategies
      %i[truncation]
    end

    def self.default_strategy
      available_strategies.first
    end

    module Base
      def db=(desired_db)
        @db = desired_db
      end

      def db
        @db || raise("You have not specified a database.  (see Mongo::Database)")
      end
    end
  end
end
