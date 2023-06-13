# frozen_string_literal: true

module BasicService
  module ClassMethods
    def call(**hash)
      new(**hash).call
    end
  end

  def self.prepended(base)
    base.extend Dry::Initializer[undefined: false]
    base.extend ClassMethods
  end

  def call
    super
    self
  end
end
