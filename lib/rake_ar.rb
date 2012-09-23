require 'rake_ar/version'
require 'active_support/inflector'
require 'fileutils'

class RakeAR
  def initialize(settings = {})
    @settings = {
      connect_file:   "#{Dir.pwd}/db/connection.rb",
      migration_path: "#{Dir.pwd}/db/migrate/",
      seed_file:      "#{Dir.pwd}/db/seeds.rb",
      schema_file:    "#{Dir.pwd}/db/schema.rb",
      models_path:    "#{Dir.pwd}/app/models"
    }.merge(settings)

    FileUtils.mkdir_p(@settings[:migration_path])
  end

  def connect_db
    @settings[:connect_file].tap do |connection|
      require connection
    end
  end

  def load_models
    "#{@settings[:models_path]}/*.rb".tap do |path|
      Dir[path].each do |model|
        require model
      end
    end
  end

  def dump_schema
    File.open(@settings[:schema_file], 'w:utf-8') do |schema_file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, schema_file)
    end 
  end

  def load_schema
    load(@settings[:schema_file]) if File.exists? @settings[:schema_file]
  end

  def seed_db
    load(@settings[:seed_file]) if File.exists? @settings[:seed_file]
  end

  def clear_db
    ActiveRecord::Base.descendants.each do |model|
      model.delete_all
    end
  end

  def drop_db
    (ActiveRecord::Base.descendants << 'schema_migration').each do |table|
      sql = "DROP TABLE #{table.to_s.pluralize.downcase};"
      ActiveRecord::Base.connection.execute(sql) rescue 1
    end
  end

  def migrate_db
    version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
    ActiveRecord::Migrator.migrate(@settings[:migration_path], version)
  end

  def create_migration
    name = ENV['NAME']
    abort 'No NAME specified. Use `rake db:create_migration NAME=create_users`' if !name

    version = ENV['VERSION'] || Time.now.utc.strftime('%Y%m%d%H%M%S') 
    migration_file = "#{version}_#{name}.rb"
    migration_name = name.gsub(/_(.)/) { $1.upcase }.gsub(/^(.)/) { $1.upcase }

    File.open("#{@settings[:migration_path]}/#{migration_file}", 'w') do |migration|
      migration << (<<-EOS).gsub('      ', '')
      class #{migration_name} < ActiveRecord::Migration
        def self.up
        end

        def self.down
        end
      end
      EOS
    end
  end
end
