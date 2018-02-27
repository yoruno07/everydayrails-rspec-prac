FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "project #{n}" }
    description "A test project."
    due_on 1.week.from_now
    association :owner
  end
end
