FactoryBot.define do
  factory :task do
    name { 'テストを書く' }
    description { 'テストテストテストテスト' }
    user
  end
end