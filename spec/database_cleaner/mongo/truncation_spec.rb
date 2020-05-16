require 'database_cleaner/mongo/truncation'
require './spec/support/database_helper'

RSpec.describe DatabaseCleaner::Mongo::Truncation do
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
    it "truncates all collections" do
      expect { subject.clean }.to change {
        [Widget.count, Gadget.count]
      }.from([1,1]).to([0,0])
    end
  end

  context "when collections are provided to the :only option" do
    subject { described_class.new(only: ['Widget']) }

    it "only truncates the specified collections" do
      expect { subject.clean }.to change {
        [Widget.count, Gadget.count]
      }.from([1,1]).to([0,1])
    end
  end

  context "when collections are provided to the :except option" do
    subject { described_class.new(except: ['Widget']) }

    it "truncates all but the specified collections" do
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

    it "truncates new collection" do
      expect { subject.clean }.to change {
        Gizmo.count
      }.from(1).to(0)
    end
  end
end

