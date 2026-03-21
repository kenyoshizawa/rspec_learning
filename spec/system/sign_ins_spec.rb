require 'rails_helper'

RSpec.describe "ログイン", type: :system do
  let(:user) { FactoryBot.create(:user) }

  it 'ログインに成功すること' do
    visit root_path
    within 'main' do
      click_link 'ログイン'
    end

    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'

    expect(current_path).to eq root_path
    expect(page).to have_content 'ログインしました。'
    expect(page).to have_content user.name
  end
end
