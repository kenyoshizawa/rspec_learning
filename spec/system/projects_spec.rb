require 'rails_helper'

RSpec.describe "Projects", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:project) { FactoryBot.create(:project, owner: user) }

  it '新規プロジェクトの登録に成功すること' do
    sign_in user
    visit root_path
    click_link "プロジェクト一覧"

    within('[data-testid=new_project]') do
      click_link 'New Project'
    end

    fill_in "プロジェクト名", with: "Test Project"
    fill_in "説明", with: "Trying out Capybara"

    expect {
      click_button "作成"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "プロジェクトの作成に成功しました"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Trying out Capybara"
      expect(page).to have_content "作成者: #{user.name}"
    end
  end

  it "プロジェクト完了処理に成功すること" do
    sign_in user
    visit root_path
    click_link "プロジェクト一覧"
    click_link project.name

    within('[data-testid=project_complete]') do
      expect(page).to_not have_content("完了", exact: true)
      click_button "未完了"
    end

    expect(project.reload.completed?).to be true
    expect(page).to have_content "プロジェクトを完了しました！"

    within('[data-testid=project_complete]') do
      expect(page).to have_content("完了", exact: true)
      expect(page).to_not have_button("未完了", exact: true)
    end
  end
end
