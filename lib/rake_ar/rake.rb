require 'bundler'
Bundler.require

require 'rake_ar'

def rake_ar
  @rake_ar ||= RakeAR.new
end

namespace :db do
  task :connect_db do
    rake_ar.connect_db
  end

  task :load_models => [:connect_db] do
    rake_ar.load_models
  end

  desc 'Loads IRB with your ActiveRecord models and a database connection'
  task :console => [:load_models] do
    require 'irb'
    require 'irb/completion'
    ARGV.clear
    IRB.start
  end

  desc 'Dumps a new schema file'
  task :schema => [:load_models] do
    rake_ar.dump_schema
  end

  desc 'Loads your schema file into the database'
  task :load => [:load_models] do
    rake_ar.load_schema
  end

  desc 'Loads your seed data file'
  task :seed => [:load_models] do
    rake_ar.seed_db
  end
  
  desc 'Clear all database records'
  task :clear => [:load_models] do
    rake_ar.clear_db
  end

  desc 'Drops all database tables'
  task :drop => [:load_models] do
    rake_ar.drop_db
  end

  desc 'Migrates your database'
  task :migrate => [:load_models] do
    rake_ar.migrate_db
  end

  desc 'Creates a new ActiveRecord migration'
  task :create_migration => [:load_models] do
    rake_ar.create_migration
  end

  desc 'Reloads the database from your schema file and reseeds it'
  task :reseed => [:load_models] do
    Rake::Task['db:load'].invoke
    Rake::Task['db:seed'].invoke
  end

  desc 'Regenerates the database from migrations'
  task :regen => [:load_models] do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:schema'].invoke
    Rake::Task['db:seed'].invoke
  end
end
