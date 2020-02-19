require_relative "boot"

require "rails/all"
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application

    config.load_defaults 5.2
    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    I18n.available_locales = [:en, :vn]
    I18n.default_locale = :en
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
