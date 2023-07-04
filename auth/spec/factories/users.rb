# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Name' }
    email { 'Email' }
    password { 'pass' }
  end
end
