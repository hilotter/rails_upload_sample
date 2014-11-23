include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user do
    name 'sample'
    profile_image { fixture_file_upload("spec/fixtures/img/sample.jpg", 'image/jpeg') }
  end
end
