require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーションに関するテスト' do
    let(:project) { FactoryBot.create(:project) }

    it 'name、project_idが存在する場合、モデルの状態は有効であること' do
      task = Task.new(project: project,
        name: "Test task",
        )
      expect(task).to be_valid
    end

    it 'nameが存在しない場合、モデルの状態は無効であること' do
      task = Task.new(name: nil)
      task.valid?
      expect(task.errors[:name]).to include("can't be blank")
    end

    it 'project_idが存在しない場合、モデルの状態は無効であること' do
      task = Task.new(project: nil)
      task.valid?
      expect(task.errors[:project]).to include("must exist")
    end
  end
end
