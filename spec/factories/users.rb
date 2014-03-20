# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "MyString"
    email "MyString"
    image "MyString"
    gid 1
    blurb "MyText"
    year "MyString"
  end
end
