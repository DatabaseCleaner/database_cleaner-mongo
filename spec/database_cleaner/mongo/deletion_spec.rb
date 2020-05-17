require 'database_cleaner/mongo/deletion'
require './spec/support/database_helper'

RSpec.describe DatabaseCleaner::Mongo::Deletion do
  let(:helper) { DatabaseHelper.new }

  around do |example|
    helper.setup
    subject.db = helper.database

    example.run

    helper.teardown
  end

  before do
    Widget.new(name: 'some widget').save!
    Gadget.new(name: 'some gadget').save!
  end

  context "by default" do
    it "deletes all collections" do
      expect { subject.clean }.to change {
        [Widget.count, Gadget.count]
      }.from([1,1]).to([0,0])
    end
  end

  context "when collections are provided to the :only option" do
    subject { described_class.new(only: ['Widget']) }

    it "only deletes the specified collections" do
      expect { subject.clean }.to change {
        [Widget.count, Gadget.count]
      }.from([1,1]).to([0,1])
    end
  end

  context "when collections are provided to the :except option" do
    subject { described_class.new(except: ['Widget']) }

    it "deletes all but the specified collections" do
      expect { subject.clean }.to change {
        [Widget.count, Gadget.count]
      }.from([1,1]).to([1,0])
    end
  end

  context "when new collection is created after clean" do
    before do
      subject.clean

      Gizmo.new(name: 'some gizmo').save!
    end

    it "deletes new collection" do
      expect { subject.clean }.to change {
        Gizmo.count
      }.from(1).to(0)
    end
  end

  context "with deprecated :cache_tables option" do
    it "prints a deprecation warning" do
      expect(DatabaseCleaner).to receive(:deprecate)
      described_class.new(cache_tables: false)
    end
  end
end

