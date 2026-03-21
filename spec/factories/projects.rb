FactoryBot.define do
  factory :project do
    # 締め切り：一週間後
    sequence(:name) { |n| "Test Project #{n}" }
    description { "Sample project for testing purposes" }
    due_on { 1.week.from_now }
    association :owner

    # 締め切り：昨日
    trait :due_yesterday do
      due_on { 1.day.ago }
    end

    # 締め切り：今日
    trait :due_today do
      due_on { Date.current.in_time_zone }
    end

    # 締め切り：明日
    trait :due_tomorrow do
      due_on { 1.day.from_now }
    end

    # 5つのノートを持つプロジェクトを作成
    trait :with_5_notes do
      after(:create) { |project| create_list(:note, 5, project: project) }
    end

    # プロジェクト名：無し
    trait :invalid do
      name { nil }
    end
  end
end
