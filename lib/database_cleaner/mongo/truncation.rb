require 'database_cleaner/generic/truncation'

module DatabaseCleaner
  module Mongo
    class Truncation
      include ::DatabaseCleaner::Generic::Truncation

      def db=(desired_db)
        @db = desired_db
      end

      def db
        @db || raise("You have not specified a database.  (see Mongo::Database)")
      end

      def clean
        if @only
          collections.each { |c| c.delete_many if @only.include?(c.name) }
        else
          collections.each { |c| c.delete_many unless @tables_to_exclude.include?(c.name) }
        end
        true
      end

      private

      def database
        db
      end

      def collections_cache
        @@collections_cache ||= {}
      end

      def mongoid_collection_names
        @@mongoid_collection_names ||= Hash.new{|h,k| h[k]=[]}.tap do |names|
          ObjectSpace.each_object(Class) do |klass|
            (names[klass.db.name] << klass.collection_name) if valid_collection_name?(klass)
          end
        end
      end

      def not_caching(db_name, list)
        @@not_caching ||= {}

        unless @@not_caching.has_key?(db_name)
          @@not_caching[db_name] = true

          puts "Not caching collection names for db #{db_name}. Missing these from models: #{list}"
        end
      end

      def collections
        return collections_cache[database.name] if collections_cache.has_key?(database.name)
        db_collections = database.collections.select { |c| c.name !~ /^system\./ }

        missing_collections = mongoid_collection_names[database.name] - db_collections.map(&:name)

        if missing_collections.empty?
          collections_cache[database.name] = db_collections
        else
          not_caching(database.name, missing_collections)
        end

        db_collections
      end

      private

      def valid_collection_name?(klass)
        klass.ancestors.map(&:to_s).include?('Mongoid::Document') &&
        !klass.embedded &&
        !klass.collection_name.empty?
      end
    end
  end
end
