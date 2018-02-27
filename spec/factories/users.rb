FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name "Aaron"
    last_name "Sumner"
    sequence(:email) { |n| "tester#{n}@exsample.com" }
    password  "dottle-nouveau-pavilion-tights-furze"
  end
end
