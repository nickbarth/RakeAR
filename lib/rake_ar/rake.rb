require 'bundler'
Bundler.require

require 'rake_ar'

def rakear
  @rakear ||= RakeAR.new
end

namespace :db do
  desc 'Load the console'
  task :console do
    require 'irb'
    require 'irb/completion'
    ARGV.clear
    IRB.start
  end

  desc 'Dump a schema file'
  task :schema do
    rakear.dump_schema
  end

  desc 'Load a schema.rb file into the database'
  task :load do
    rakear.load_schema
  end

  desc 'Load the seed data'
  task :seed do
    rakear.seed_db
  end
  
  desc 'Clear all database records'
  task :clear do
    rakear.clear_db
  end

  desc 'Drop all database tables'
  task :drop do
    rakear.drop_db
  end

  desc 'migrate your database'
  task :migrate do
    rakear.migrate_db
  end

  desc 'create an ActiveRecord migration in ./db/migrate'
  task :create_migration do
    rakear.create_migration
  end

  desc 'Reload and reseed the database from schema'
  task :reseed do
    Rake::Task['db:load'].invoke
    Rake::Task['db:seed'].invoke
  end

  desc 'Regenerates the database from migrations'
  task :regen do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:schema'].invoke
    Rake::Task['db:seed'].invoke
  end
end
