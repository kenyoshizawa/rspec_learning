require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションに関するテスト' do
    it 'first_name、last_name、email、passwordが存在する場合、モデルの状態は有効であること' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
    it { is_expected.to validate_presence_of :email }

    subject { FactoryBot.build(:user) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    # it 'first_nameが存在しない場合、モデルの状態は無効であること' do
    #   user = FactoryBot.build(:user, first_name: nil)
    #   user.valid?
    #   expect(user.errors[:first_name]).to include("can't be blank")
    # end

    # it 'last_nameが存在しない場合、モデルの状態は無効であること' do
    #   user = FactoryBot.build(:user, last_name: nil)
    #   user.valid?
    #   expect(user.errors[:last_name]).to include("can't be blank")
    # end

    # it 'emailが存在しない場合、モデルの状態は無効であること' do
    #   user = FactoryBot.build(:user, email: nil)
    #   user.valid?
    #   expect(user.errors[:email]).to include("can't be blank")
    # end

    # it 'emailが重複している場合、モデルの状態は無効であること' do
    #   FactoryBot.create(:user, email: "aaron@example.com")
    #   user = FactoryBot.build(:user, email: "aaron@example.com")
    #   user.valid?
    #   expect(user.errors[:email]).to include('has already been taken')
    # end
  end

  describe 'インスタンスメソッド name に関するテスト' do
    it 'ユーザーのフルネームが出力されること' do
      user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
      expect(user.name).to eq "John Doe"
    end
  end
end
