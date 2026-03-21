require 'rails_helper'

RSpec.describe "ログアウト", type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }

  it 'ログアウトに成功すること' do
    sign_in user
    visit root_path

    page.accept_confirm('本当にログアウトしますか？') do
      click_link 'ログアウト'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content('ログアウトしました。')
  end
end
