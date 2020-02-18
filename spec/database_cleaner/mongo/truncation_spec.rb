require 'mongo'
require 'database_cleaner/mongo/truncation'
require './spec/support/database_helper'

RSpec.describe DatabaseCleaner::Mongo::Truncation do
  around do |example|
    subject.db = MongoTest::Base.database

    example.run

    MongoTest::Base.drop_database
  end

  before do
    MongoTest::Widget.new(name: 'some widget').save!
    MongoTest::Gadget.new(name: 'some gadget').save!
  end

  context "by default" do
    it "truncates all collections" do
      expect { subject.clean }.to change {
        [MongoTest::Widget.count, MongoTest::Gadget.count]
      }.from([1,1]).to([0,0])
    end
  end

  context "when collections are provided to the :only option" do
    subject { described_class.new(only: ['MongoTest::Widget']) }

    it "only truncates the specified collections" do
      expect { subject.clean }.to change {
        [MongoTest::Widget.count, MongoTest::Gadget.count]
      }.from([1,1]).to([0,1])
    end
  end

  context "when collections are provided to the :except option" do
    subject { described_class.new(except: ['MongoTest::Widget']) }

    it "truncates all but the specified collections" do
      expect { subject.clean }.to change {
        [MongoTest::Widget.count, MongoTest::Gadget.count]
      }.from([1,1]).to([1,0])
    end
  end
end

