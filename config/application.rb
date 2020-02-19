require_relative "boot"

require "rails/all"
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
  # config.load_default 5.2
  # config.i18n.default_locate = :en
  end
end

