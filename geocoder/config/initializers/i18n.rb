# frozen_string_literal: true

I18n.load_path += Dir[File.expand_path('../locales/**/*.yml', __dir__)]
I18n.available_locales = %i[en]
I18n.default_locale = :en
