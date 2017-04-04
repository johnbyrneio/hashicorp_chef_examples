# This is an example of retrieving a value from Consul within a Chef recipe.
# It requires that you have a Consul agent running on the Chef node.
# It uses the diplomat gem to interact with the Consul API - https://github.com/WeAreFarmGeek/diplomat
# Depending on your use case, Consul Template may be a better option for consuming
# this data, but this can be useful for cases where you don't need immediate run-time updating.

# Install the Diplomat Gem into Chef's Ruby environment
chef_gem 'diplomat'

# And require it
require 'diplomat'

# Retrieve a value from Consul. Much like how we'd retrieve something from a data bag
my_setting = Diplomat::Kv.get('my_app/my_setting')

# Use that value in a Chef file resource
file '/tmp/my_app.conf' do
	content my_setting
end

# Or within a Chef template resource
template "/tmp/my_app.conf" do
  source "my_app.conf.erb"
  variables(
    :my_setting => my_setting
  )
end