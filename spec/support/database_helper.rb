require "mongo"

class DatabaseHelper
  def host
    @host ||= "127.0.0.1"
  end

  def db_name
    @db_name ||= "database_cleaner_mongo"
  end

  def connection
    @connection ||= if mongo2?
      Mongo::Client.new("mongodb://#{host}/#{db_name}")
    else
      Mongo::Connection.new(host).tap { |c| c.db(db_name) }
    end
  end

  def database
    if mongo2?
      connection.database
    else
      connection.db(db_name)
    end
  end

  def setup
    database
  end

  def teardown
    if mongo2?
      connection.database.drop
    else
      connection.drop_database(db_name)
    end
  end

  private

  def mongo2?
    defined?(Mongo::Client)
  end

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
      if mongo2?
        collection.insert_one(@attrs)
      else
        collection.insert(@attrs)
      end
    end
  end
end

class Widget < DatabaseHelper::Base
end

class Gadget < DatabaseHelper::Base
end

