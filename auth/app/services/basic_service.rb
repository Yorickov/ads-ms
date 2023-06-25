# frozen_string_literal: true

module BasicService
  module ClassMethods
    def call(...)
      new(...).call
    end
  end

  def self.prepended(base)
    base.extend Dry::Initializer[undefined: false]
    base.extend ClassMethods
  end

  attr_reader :errors

  def initialize(...)
    super(...)

    @errors = []
  end

  def call
    super

    self
  end

  def success?
    !failure?
  end

  def failure?
    @errors.any?
  end

  private

  def fail!(messages)
    @errors += Array(messages)
    self
  end
end
