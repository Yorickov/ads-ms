# frozen_string_literal: true

module Auth
  class FetchUserService
    UUID_MATCHER = /(\h{8}(?:-\h{4}){3}-\h{12})/.freeze

    prepend BasicService

    param :uuid

    attr_reader :user

    def call
      return fail!(I18n.t('services.auth.fetch_user_service.forbidden')) if !uuid_valid? || session.blank?

      @user = session.user
    end

    private

    def uuid_valid?
      UUID_MATCHER.match?(@uuid)
    end

    def session
      @session ||= UserSession.first(uuid: @uuid)
    end
  end
end
