lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake_ar/version'

Gem::Specification.new do |gem|
  gem.name          = 'rake-ar'
  gem.date          = '2012-09-22'
  gem.version       = RakeAR::VERSION
  gem.authors       = ['Nick Barth']
  gem.email         = ['nick@nickbarth.ca']
  gem.summary       = 'A Ruby Gem for common ActiveRecord Rake tasks.'
  gem.description   = 'RakeAR is a Ruby Gem containing some common Rake tasks to help manage your ActiveRecord database independant of Rails.'
  gem.homepage      = 'https://github.com/nickbarth/RakeAR'

  gem.add_dependency('rake')
  gem.add_dependency('activerecord')
  gem.add_development_dependency('rspec')

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep /spec/
  gem.require_paths = ['lib']
end
