# This is an example of retrieving a secret from Hasicorp Vault within a Chef recipe.
# It requires that you have network access and a valid token to access a Vault server.
# It uses the vault gem to interact with the Vault API
# Depending on your use case, Consul Template may be a better option for consuming
# this data, but this can be useful for cases where you don't need immediate run-time updating.

# Install the vault gem into Chef's Ruby environment
chef_gem 'vault'

# And require it
require 'vault'

# Setup the client connection
Vault.address = "http://127.0.0.1:8200" # You can skip this if you define ENV["VAULT_ADDR"]
Vault.token   = "691be83e-1b4d-81f5-044a-ea738ce44dea" # You can skip this if you define ENV["VAULT_TOKEN"]

# Retrieve the secret from Vault
my_secret = Vault.logical.read("my_app/my_secret")

# Use my secret within a Chef file resource
file '/tmp/my_app.conf' do
  content "#{my_secret.data[:username]}:#{my_secret.data[:password]}"
end

# Or within a Chef template resource
template "/tmp/my_app.conf" do
  source "my_app.conf.erb"
  sensitive true
  variables(
    :username => my_secret.data[:username],
    :password => my_secret.data[:password],
  )
end
