FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "title#{n}" }
    content { "RSpec編の課題2" }
    status { :todo }
    deadline { 1.week.from_now }
    association :user
  end
end
