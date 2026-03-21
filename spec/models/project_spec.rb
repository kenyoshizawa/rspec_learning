require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'バリデーションに関するテスト' do
    subject { FactoryBot.build(:project) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

    # it '同一ユーザーは同じnameのプロジェクトを登録できないこと' do
    #   debugger
    #   user = FactoryBot.create(:user)
    #   user.projects.create(
    #     name: "Test Project",
    #   )
    #   new_project = user.projects.build(
    #     name: "Test Project",
    #   )
    #   new_project.valid?
    #   expect(new_project.errors.of_kind?(:name, :taken)).to be_truthy
    # end

    # it '異なるユーザーであれば同じnameのプロジェクトを登録できること' do
    #   user = FactoryBot.create(:user)
    #   user.projects.create(
    #     name: "Test Project",
    #   )
    #   other_user = FactoryBot.create(:user)
    #   other_project = other_user.projects.build(
    #     name: "Test Project",
    #   )
    #   expect(other_project).to be_valid
    # end
  end

  describe "インスタンスメソッド late? に関するテスト" do
    it "締切日が昨日の場合、プロジェクトは遅延していること" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it "締切日が今日の場合、プロジェクトは期限内であること" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    it "締切日が未来の場合、プロジェクトは期限内であること" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end

  describe 'コールバックに関するテスト' do
    it "projectインスタンス登録後、5つのnoteインスタンスが登録されること" do
      project = FactoryBot.create(:project, :with_5_notes)
      expect(project.notes.length).to eq 5
    end
  end
end
