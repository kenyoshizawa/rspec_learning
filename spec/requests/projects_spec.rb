require 'rails_helper'

RSpec.describe "Projects", type: :request do
  describe "GET #index" do
    it "returns http success" do
      get "/projects/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end

      # 有効な属性値の場合
      context "with valid attributes" do
        # プロジェクトを追加できること
        it "adds a project" do
          sign_in @user
          expect {
            post projects_path, params: { project: FactoryBot.attributes_for(:project) }
          }.to change(@user.projects, :count).by(1)
        end
      end

      # 無効な属性値の場合
      context "with invalid attributes" do
        # プロジェクトを追加できないこと
        it "does not add a project" do
          sign_in @user
          expect {
            post projects_path, params: { project: FactoryBot.attributes_for(:project, :invalid) }
          }.to_not change(@user.projects, :count)
        end
      end
    end
  end
end
