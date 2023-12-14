# Rails template to build the sample app for specs

generate :model, 'author name:string{10}:uniq last_name:string birthday:date'
generate :model, 'post title:string:uniq body:text author:references'

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

# Configure default_url_options in test environment
inject_into_file "config/environments/test.rb", after: "config.cache_classes = true\n" do
  "  config.action_mailer.default_url_options = { :host => 'example.com' }\n"
end

# Add our local Active Admin to the load path
inject_into_file "config/environment.rb", after: "require File.expand_path('../application', __FILE__)" do
  "\n$LOAD_PATH.unshift('#{File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))}')\nrequire \"active_admin\"\n"
end

run "rm Gemfile"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

generate :'active_admin:install --skip-users'
generate :'formtastic:install'

# Install active_admin_date_time_datetimepicker assets
inject_into_file "app/assets/stylesheets/active_admin.scss" do
  "@import \"active_admin_datetimepicker\";\n"
end

inject_into_file "app/assets/javascripts/active_admin.js" do
  "//= require active_admin_datetimepicker\n"
end

run "rm -r test"
run "rm -r spec"

route "root :to => 'admin/dashboard#index'"

rake "db:migrate"
