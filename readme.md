# RakeAR
RakeAR is a Ruby Gem containing some common Rake tasks to help manage your ActiveRecord database independant of Rails.

# How To Use

Install the gem 

    gem install rake-ar

Add a require to your `Rakefile`

    require 'rake_ar/rake'

Now you will have some rake tasks to manage your ActiveRecord database.

    rake -T

    rake assets:compile       # Compiles both CSS and Javascript
    rake assets:check         # Checks that the configuration paths are valid
    rake assets:compile_js    # Compiles Javascript files into a single minified Javascript file
    rake assets:compile_css   # Compiles CSS files into a single minified CSS file

To configure them just initialize a new instance of RakeAR in your `Rakefile` to override the defaults.

    @rake_assets = RakeAssets.new js_path:      'app/assets/scripts',                        # Location of application.js
                                  js_compiled:  "#{Dir.pwd}/public/scripts/application.js",  # Path to compile JS too
                                  css_path:     'app/assets/styles',                         # Path of application.css file
                                  css_compiled: "#{Dir.pwd}/public/css/style.css",           # Path to compile CSS too

### License
WTFPL &copy; 2012 Nick Barth
