require 'spec_helper'

describe RakeAR do
  before(:all) do
    ActiveRecord = Module.new
    ActiveRecord::Base = Struct.new(:connection, :descendants).new
    module FileUtils; def self.mkdir_p(*args); true; end; end
    class File; def self.open(*args); yield; end; end
  end

  before(:each) do
    @rake_ar = RakeAR.new connect_file:   'CONNECT_FILE',
                          migration_path: 'MIG_PATH',
                          seed_file:      'SEED_FILE',
                          schema_file:    'SCHEMA_FILE',
                          models_path:    'MODELS_PATH'
  end
  
  context 'on create connection' do
    it 'should return correct path' do
      @rake_ar.stub(:require)
      @rake_ar.connect_db.should == 'CONNECT_FILE'
    end
  end

  context 'on model path' do
    it 'should return correct path' do
      @rake_ar.load_models.should == 'MODELS_PATH/*.rb'
    end
  end

  context 'on schema dump' do
    it 'should dump to the schema file' do
      ActiveRecord::SchemaDumper = double(:schema)
      ActiveRecord::SchemaDumper.should_receive(:dump)
      @rake_ar.dump_schema
    end
  end

  context 'on load schema' do
    it 'should load the schema file' do
      File.stub(:exists?).and_return(true)
      @rake_ar.should_receive(:load).with('SCHEMA_FILE')
      @rake_ar.load_schema
    end
  end

  context 'on seed db' do
    it 'should load the schema file' do
      File.stub(:exists?).and_return(true)
      @rake_ar.should_receive(:load).with('SEED_FILE')
      @rake_ar.seed_db
    end
  end

  context 'on clear db' do
    it 'should send all models delete_all' do
      model = stub(:model)
      model.should_receive(:delete_all)
      ActiveRecord::Base.descendants = [model]
      @rake_ar.clear_db
    end
  end
  
  context 'on drop db' do
    it 'should execute drop tables' do
      ActiveRecord::Base.descendants = [ Struct.new(:to_s).new('model') ]
      ActiveRecord::Base.connection = stub
      ActiveRecord::Base.connection.should_receive(:execute).with('DROP TABLE models;')
      ActiveRecord::Base.connection.should_receive(:execute).with('DROP TABLE schema_migrations;')
      @rake_ar.drop_db
    end
  end
  
  context 'on migrate' do
    it 'should call migrate' do
      ENV['VERSION'] = '42'
      ActiveRecord::Migrator = double(:migrator)
      ActiveRecord::Migrator.should_receive(:migrate).with('MIG_PATH', 42)
      @rake_ar.migrate_db
    end
  end

  context 'on create migration' do
    it 'should write a new migration file' do
      ENV['VERSION'] = '42'
      ENV['NAME'] = 'add_models'
      File.should_receive(:open).with('MIG_PATH/42_add_models.rb', 'w')
      @rake_ar.create_migration
    end
  end
end
