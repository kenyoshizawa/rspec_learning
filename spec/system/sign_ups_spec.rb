require 'rails_helper'

RSpec.describe "ユーザー登録", type: :system do
  it 'ユーザー登録に成功すること' do
    visit root_path
    click_link "新規登録"

    fill_in "氏", with: "First"
    fill_in "名", with: "Last"
    fill_in "メールアドレス", with: "test@example.com"
    fill_in "パスワード", with: "test123"
    fill_in "パスワード（確認用）", with: "test123"

    expect {
      click_button "アカウント作成"
    }.to change(User, :count).by(1)

    expect(current_path).to eq root_path
    expect(page).to have_content "アカウント登録が完了しました。"
  end
end
