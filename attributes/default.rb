# lita - core configuration

# The Lita gem version to install.  By default it uses pessimistic version
# constraints, so will install the latest gem in the 4.0.X line.
default["lita"]["version"] = "4.0.0"
default["lita"]["version_constraint"] = "~>"

# The name your robot will use.
default["lita"]["name"] = "Lita Chatbot"

# The name Lita will look for in messages to determine if the message is being
# addressed to it. Usually this is the same as the display name, but in some
# cases it may not be. For example, in HipChat, display names are required to
# be a first and last name, such as "Lita Bot", whereas the mention system
# would use a name like "LitaBot".
default["lita"]["mention_name"] = node["lita"]["name"]

# The cookbook to find the config template (allows for wrapper cookbooks to
# override with custom template for more complex configurations)
default["lita"]["config_cookbook"] = "lita"
default["lita"]["config_template"] = "lita_config.rb.erb"
default["lita"]["gemfile_template"] = "Gemfile.erb"
default["lita"]["init_template"] = "lita.erb"

# The locale code for the language to use.
default["lita"]["locale"] = :en

# The severity of messages to log. Options are:
# :debug, :info, :warn, :error, :fatal
# Messages at the selected level and above will be logged.
default["lita"]["log_level"] = :info

# An array of user IDs that are considered administrators. These users
# the ability to add and remove other users from authorization groups.
# What is considered a user ID will change depending on which adapter you use.
default["lita"]["admin"] = []

# An array of adapters you want to connect with. Recipe will auto-install any
# adapter found here: https://www.lita.io/plugins
default["lita"]["adapters"] = [:shell]

# Hash of adapter versions to install (using Gemfile format); nil for latest
# Example:
#
# default["lita"]["adapter_versions"] = { :hipchat => 1.6.2 }
default["lita"]["adapter_versions"] = { :shell => nil }

# Hash of configurations specific to adapters above:
# Example:
#
# default["lita"]["adapter_config"] = {
#   "hipchat" => {
#     "jid"        => "HIPCHAT_JID",
#     "password"   => "HIPCHAT_PASSWORD",
#     "rooms"      => ["HIPCHAT_ROOM"],
#     "muc_domain" => "conf.hipchat.com",
#     "debug"      => false
#   },
#   "adapter_2" => {
#     "ATTR1"     => "VAL1",
#     "ATTR2"     => "VAL2"
#   }
# }
default["lita"]["adapter_config"] = {}

# Array of plugin to install OR hashes of plugins and Gemfile formatted line
# Example:
#
# default["lita"]["plugins"] = [
#  "ping",
#  { "jenkins" => ">= 0.0.1" }
#  { "foo" => ">= 1.2.3, :git => 'git://github.com/foo/foo.git'" }
# ]
#
default["lita"]["plugins"] = []

# Array of extra gems to install OR hashes of gems and Gemfile formatted line
# See above for example.
default["lita"]["gems"] = []

# Configuration specific to plugin list above. Example:
#
# default["lita"]["plugin_config"] = {
#   "jenkins" => {
#     "url" => "http://test.com"
#     "auth" => ""user1:sekret""
#   }
# }
#
default["lita"]["plugin_config"] = {}

# helpful for adding native libs needed by adapters / handlers
default["lita"]["packages"] = %w(
  openssl
  libssl-dev
  ca-certificates
  libcurl4-gnutls-dev
)

# The init system to configure Lita for.
# Valid values are 'runit', 'init' (for sysv init), and 'systemd'
default['lita']['init_style'] =  value_for_platform_family(
  'rhel' => { '>= 7.0' => 'systemd' }
) || 'runit'

# Set options for redis connection
default["lita"]["redis_host"] = "127.0.0.1"
default["lita"]["redis_port"] = 6379

# Set options for http server
default["lita"]["http_host"]        = "0.0.0.0"
default["lita"]["http_port"]        = 8080
default["lita"]["http_min_threads"] = 0
default["lita"]["http_max_threads"] = 16

# directories, files, etc.
default["lita"]["install_dir"] = "/opt/lita"
default["lita"]["log_dir"]     = "/opt/lita/logs"
default["lita"]["run_dir"]     = "/opt/lita/run"

# daemon user - must already exist
default["lita"]["daemon_user"] = "nobody"
default["lita"]["daemon_group"] = value_for_platform_family(
    "debian" => "nogroup",
    "rhel" => "nobody"
  )

# Platform-specific Redis package name
default["lita"]["redis"]["package"] = value_for_platform_family(
    "debian" => "redis-server",
    "rhel" => "redis"
  )

# Ruby
default["rvm"]["default_ruby"] = "ruby-2.2.2"
default["rvm"]["user_default_ruby"] = "ruby-2.2.2"

# runit
# TODO: valid values here?
default['lita']['runit']['finish'] = false
default['lita']['runit']['env'] = {
  'HOME' => node['lita']['install_dir'],
  'PATH' => [node['languages']['ruby']['bin_dir'],
             node['languages']['ruby']['gem_bin'],
             node['languages']['ruby']['ruby_dir']
             ].join(':')
}