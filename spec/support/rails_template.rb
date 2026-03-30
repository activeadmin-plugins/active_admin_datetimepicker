# Rails template to build the sample app for specs

# Ensure Sprockets manifest exists (required by Rails 8+)
FileUtils.mkdir_p("app/assets/config")
File.write("app/assets/config/manifest.js",
  "//= link_directory ../javascripts .js\n//= link_directory ../stylesheets .css\n")

generate :model, 'author name:string{10}:uniq last_name:string birthday:date --force'
generate :model, 'post title:string:uniq body:text author:references --force'

# Compatibility with old ransack
inject_into_file "app/models/application_record.rb", after: "primary_abstract_class\n" do
  <<-STRING

    def self.ransackable_attributes(auth_object=nil)
      if respond_to?(:authorizable_ransackable_attributes)
        authorizable_ransackable_attributes
      else
        super
      end
    end

    def self.ransackable_associations(auth_object=nil)
      if respond_to?(:authorizable_ransackable_associations)
        authorizable_ransackable_associations
      else
        super
      end
    end
  STRING
end

# Virtual attributes
inject_into_file "app/models/author.rb", after: "ApplicationRecord\n" do
  <<-STRING
  validates_presence_of :name
  validates_uniqueness_of :last_name

  def self.ransackable_attributes(auth_object=nil)
    if respond_to?(:authorizable_ransackable_attributes)
      authorizable_ransackable_attributes
    else
      %w(birthday created_at last_seen_at updated_at)
    end
  end

  attr_accessor :last_seen_at

  ransacker :last_seen_at do
    Arel.sql('updated_at')
  end
  STRING
end

# Add our local Active Admin to the load path (Rails 7.1+ uses require_relative)
gsub_file "config/environment.rb",
  'require_relative "application"',
  "require_relative \"application\"\n$LOAD_PATH.unshift('#{File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))}')\nrequire \"active_admin\"\n"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

generate :'active_admin:install --skip-users'
generate :'formtastic:install'

# Install active_admin_datetimepicker assets
inject_into_file "app/assets/stylesheets/active_admin.scss" do
  "@import \"active_admin_datetimepicker\";\n"
end

inject_into_file "app/assets/javascripts/active_admin.js" do
  "//= require active_admin_datetimepicker\n"
end

run "rm -rf test"
route "root :to => 'admin/dashboard#index'"
rake "db:migrate"

# Remove Gemfile last so rake/route/generate work during template
run "rm -f Gemfile Gemfile.lock"
