require "mongo"

Mongo::Logger.logger.level = Logger::FATAL

class DatabaseHelper
  def host
    @host ||= "127.0.0.1"
  end

  def db_name
    @db_name ||= "database_cleaner_mongo"
  end

  def connection
    @connection ||= Mongo::Client.new("mongodb://#{host}/#{db_name}")
  end

  def database
    connection.database
  end

  def setup
    database
  end

  def teardown
    connection.database.drop
  end

  private

  class Base < self
    def self.count
      new.collection.count
    end

    def collection
      name = self.class.name
      database.collection(name) || database.create_collection(name)
    end

    def initialize(attrs={})
      @attrs = attrs
    end

    def save!
      collection.insert_one(@attrs)
    end
  end
end

class Widget < DatabaseHelper::Base
end

class Gadget < DatabaseHelper::Base
end

