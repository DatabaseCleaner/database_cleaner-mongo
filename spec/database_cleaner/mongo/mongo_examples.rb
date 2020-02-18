module MongoTest
  class Base
    def self.connection
      @connection ||= Mongo::Client.new("mongodb://127.0.0.1/database_cleaner_specs")
    end

    def self.collection
      connection[name]
    end

    def self.count
      collection.count
    end

    def initialize(attrs={})
      @attrs = attrs
    end

    def save!
      self.class.collection.insert_one(@attrs)
    end
  end

  class Widget < Base
  end

  class Gadget < Base
  end
end
