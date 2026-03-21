require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'バリデーションに関するテスト' do
    it 'message、user_id、project_idが存在する場合、モデルの状態は有効であること' do
      note = FactoryBot.build(:note)
      expect(note).to be_valid
    end

    it 'messageが存在しない場合、モデルの状態は無効であること' do
      note = FactoryBot.build(:note, message: nil)
      note.valid?
      expect(note.errors.of_kind?(:message, :blank)).to be_truthy
    end
  end

  describe 'クラスメソッド（スコープ）search に関するテスト' do
    let(:user) { FactoryBot.create(:user) }
    let(:project) { FactoryBot.create(:project, owner: user) }
    let!(:note1) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "This is the first note.",
      )
    }
    let!(:note2) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "This is the second note.",
      )
    }
    let!(:note3) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "First, preheat the oven.",
      )
    }

    context '一致するデータが見つかった場合' do
      it '検索文字列に一致するmessageを返すこと' do
        expect(Note.search("first")).to include(note1)
        expect(Note.search("first")).to include(note3)
        expect(Note.search("first")).not_to include(note2)
      end
    end

    context '一致するデータが1件も見つからなかった場合' do
      it '空のコレクションを返すこと' do
        expect(Note.search("message")).to be_empty
        expect(Note.count).to eq 3
      end
    end
  end

  # 名前の取得をメモを作成したユーザーに委譲すること
  it "delegates name to the user who created it" do
    user = instance_double("User", name: "Fake User")
    note = Note.new
    allow(note).to receive(:user).and_return(user)
    expect(note.user_name).to eq "Fake User"
  end
end
