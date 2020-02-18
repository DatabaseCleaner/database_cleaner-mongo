require "mongo"

module MongoTest
  class Base
    def self.host
      @host ||= "127.0.0.1"
    end

    def self.db_name
      @db_name ||= "database_cleaner_mongo"
    end

    def self.connection
      @connection ||= if defined?(Mongo::Client)
        Mongo::Client.new("mongodb://#{host}/#{db_name}")
      else
        Mongo::Connection.new(host).tap { |c| c.db(db_name) }
      end
    end

    def self.database
      if connection.respond_to?(:database)
        connection.database
      else
        connection.db(db_name)
      end
    end

    def self.drop_database
      if connection.respond_to?(:drop_database)
        connection.drop_database(db_name)
      else
        connection.database.drop
      end
    end

    def self.collection
      database.collection(name) || database.create_collection(name)
    end

    def self.count
      collection.count
    end

    def initialize(attrs={})
      @attrs = attrs
    end

    def save!
      if self.class.collection.respond_to?(:insert_one)
        self.class.collection.insert_one(@attrs)
      else
        self.class.collection.insert(@attrs)
      end
    end
  end

  class Widget < Base
  end

  class Gadget < Base
  end
end

