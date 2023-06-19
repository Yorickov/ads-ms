# frozen_string_literal: true

FactoryBot.define do
  factory :ad do
    title { 'Title' }
    description { 'Description' }
    city { 'City' }
    user_id { 101 }
  end
end
