require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do
    context "ログイン済みユーザーの場合" do
      before do
        @user = FactoryBot.create(:user)
      end

      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :index

        # aggregate_failures (失敗の集約)
        aggregate_failures do
          expect(response).to have_http_status "200"
          expect(response).to render_template :index
        end
      end

      # it "ステータスコード200を返すこと" do
      #   sign_in @user
      #   get :index
      #   expect(response).to have_http_status "200"
      # end

      # it "indexテンプレートをレンダリングすること" do
      #   sign_in @user
      #   get :index
      #   expect(response).to render_template :index
      # end
    end

    context "ログインしていないユーザーの場合" do
      it "ステータスコード302を返すこと" do
        get :index
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    context "ログイン済みユーザーの場合" do
      context "認可されたユーザーの場合" do
        before do
          @user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: @user)
        end

        it "ステータスコード200を返すこと" do
          sign_in @user
          get :show, params: { id: @project.id }
          expect(response).to have_http_status "200"
        end

        it 'プロジェクトが取得できること' do
          sign_in @user
          get :show, params: { id: @project.id }
          expect(assigns(:project)).to eq @project
        end

        it "showテンプレートをレンダリングすること" do
          sign_in @user
          get :show, params: { id: @project.id }
          expect(response).to render_template :show
        end
      end

      context "認可されていないユーザーの場合" do
        before do
          @user = FactoryBot.create(:user)
          other_user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: other_user)
        end

        it "ステータスコード302を返すこと" do
          sign_in @user
          get :show, params: { id: @project.id }
          expect(response).to have_http_status "302"
        end

        it "ルート画面にリダイレクトすること" do
          sign_in @user
          get :show, params: { id: @project.id }
          expect(response).to redirect_to root_path
        end

        it "アクセス権限がない旨のフラッシュメッセージが表示されること" do
          sign_in @user
          get :show, params: { id: @project.id }
          expect(flash[:alert]).to eq I18n.t("errors.access_denied.project")
        end
      end
    end

    context "ログインしていないユーザーの場合" do
      before do
        @project = FactoryBot.create(:project)
      end

      it "ステータスコード302を返すこと" do
        get :show, params: { id: @project.id }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        get :show, params: { id: @project.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#new" do
    context "ログイン済みユーザーの場合" do
      before do
        @user = FactoryBot.create(:user)
      end

      it "ステータスコード200を返すこと" do
        sign_in @user
        get :new
        expect(response).to have_http_status "200"
      end

      it "新しいプロジェクトが作成されること" do
        sign_in @user
        get :new
        expect(assigns(:project)).to be_a_new(Project)
      end

      it "newテンプレートをレンダリングすること" do
        sign_in @user
        get :new
        expect(response).to render_template :new
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ステータスコード302を返すこと" do
        get :new
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        get :new
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#create" do
    context "ログイン済みユーザーの場合" do
      before do
        @user = FactoryBot.create(:user)
      end

      context "有効なパラメータを送信した場合" do
        it "ステータスコード303を返すこと" do
          sign_in @user
          post :create, params: { project: FactoryBot.attributes_for(:project) }
          expect(response).to have_http_status "303"
        end

        it "プロジェクトの作成・保存に成功すること" do
          sign_in @user
          expect {
            post :create, params: { project: FactoryBot.attributes_for(:project) }
          }.to change(@user.projects, :count).by(1)
        end

        it 'プロジェクト詳細画面にリダイレクトすること' do
          sign_in @user
          post :create, params: { project: FactoryBot.attributes_for(:project) }
          expect(response).to redirect_to project_url(assigns(:project))
        end

        it "作成成功のフラッシュメッセージが表示されること" do
          sign_in @user
          post :create, params: { project: FactoryBot.attributes_for(:project) }
          expect(flash[:notice]).to eq I18n.t("projects.create.success")
        end
      end

      context "無効なパラメータを送信した場合" do
        it "ステータスコード422を返すこと" do
          sign_in @user
          post :create, params: { project: FactoryBot.attributes_for(:project, :invalid) }
          expect(response).to have_http_status "422"
        end

        it "プロジェクトの作成・保存に失敗すること" do
          sign_in @user
          expect {
            post :create, params: { project: FactoryBot.attributes_for(:project, :invalid) }
          }.not_to change(@user.projects, :count)
        end

        it "newテンプレートをレンダリングすること" do
          sign_in @user
          post :create, params: { project: FactoryBot.attributes_for(:project, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ステータスコード302を返すこと" do
        post :create, params: { project: FactoryBot.attributes_for(:project) }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        post :create, params: { project: FactoryBot.attributes_for(:project) }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe '#edit' do
    context "ログイン済みユーザーの場合" do
      context "認可されたユーザーの場合" do
        before do
          @user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: @user)
        end

        it "ステータスコード200を返すこと" do
          sign_in @user
          get :edit, params: { id: @project.id }
          expect(response).to have_http_status "200"
        end

        it 'プロジェクトが取得できること' do
          sign_in @user
          get :edit, params: { id: @project.id }
          expect(assigns(:project)).to eq @project
        end

        it "editテンプレートをレンダリングすること" do
          sign_in @user
          get :edit, params: { id: @project.id }
          expect(response).to render_template :edit
        end
      end

      context "認可されていないユーザーの場合" do
        before do
          @user = FactoryBot.create(:user)
          other_user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: other_user)
        end

        it "ステータスコード302を返すこと" do
          sign_in @user
          get :edit, params: { id: @project.id }
          expect(response).to have_http_status "302"
        end

        it "ルート画面にリダイレクトすること" do
          sign_in @user
          get :edit, params: { id: @project.id }
          expect(response).to redirect_to root_path
        end

        it "アクセス権限がない旨のフラッシュメッセージが表示されること" do
          sign_in @user
          get :edit, params: { id: @project.id }
          expect(flash[:alert]).to eq I18n.t("errors.access_denied.project")
        end
      end
    end

    context "ログインしていないユーザーの場合" do
      before do
        @project = FactoryBot.create(:project)
      end

      it "ステータスコード302を返すこと" do
        get :show, params: { id: @project.id }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        get :show, params: { id: @project.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do
    context "ログイン済みユーザーの場合" do
      context "認可されたユーザーの場合" do
        before do
          @user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: @user, name: "Same Old Name")
        end

        context "有効なパラメータを送信した場合" do
          it "ステータスコード303を返すこと" do
            sign_in @user
            patch :update, params: { id: @project.id, project: FactoryBot.attributes_for(:project, name: "New Project Name") }
            expect(response).to have_http_status "303"
          end

          it "プロジェクトの更新に成功すること" do
            sign_in @user
            patch :update, params: { id: @project.id, project: FactoryBot.attributes_for(:project, name: "New Project Name") }
            expect(@project.reload.name).to eq "New Project Name"
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            sign_in @user
            patch :update, params: { id: @project.id, project: FactoryBot.attributes_for(:project, name: "New Project Name") }
            expect(response).to redirect_to project_url(assigns(:project))
          end

          it "更新成功のフラッシュメッセージが表示されること" do
            sign_in @user
            patch :update, params: { id: @project.id, project: FactoryBot.attributes_for(:project, name: "New Project Name") }
            expect(flash[:notice]).to eq I18n.t("projects.update.success")
          end
        end

        context "無効なパラメータを送信した場合" do
          it "ステータスコード422を返すこと" do
            sign_in @user
            patch :update, params: { id: @project.id, project: FactoryBot.attributes_for(:project, :invalid) }
            expect(response).to have_http_status "422"
          end

          it "プロジェクトの更新に失敗すること" do
            sign_in @user
            expect {
              patch :update, params: { id: @project.id, project: FactoryBot.attributes_for(:project, :invalid) }
            }.not_to change { @project.reload.name }
          end

          it "editテンプレートをレンダリングすること" do
            sign_in @user
            patch :update, params: { id: @project.id, project: FactoryBot.attributes_for(:project, :invalid) }
            expect(response).to render_template :edit
          end
        end
      end

      context "認可されていないユーザーの場合" do
        before do
          @user = FactoryBot.create(:user)
          other_user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: other_user, name: "Same Old Name")
        end

        it "ステータスコード302を返すこと" do
          sign_in @user
          patch :update, params: { id: @project.id, project: FactoryBot.attributes_for(:project, name: "New Project Name") }
          expect(response).to have_http_status "302"
        end

        it 'ルート画面にリダイレクトすること' do
          sign_in @user
          patch :update, params: { id: @project.id, project: FactoryBot.attributes_for(:project, name: "New Project Name") }
          expect(response).to redirect_to root_path
        end

        it "アクセス権限がない旨のフラッシュメッセージが表示されること" do
          sign_in @user
          patch :update, params: { id: @project.id, project: FactoryBot.attributes_for(:project, name: "New Project Name") }
          expect(flash[:alert]).to eq I18n.t("errors.access_denied.project")
        end
      end
    end

    context "ログインしていないユーザーの場合" do
      before do
        @project = FactoryBot.create(:project, name: "Same Old Name")
      end

      it "ステータスコード302を返すこと" do
        patch :update, params: { id: @project.id, project: FactoryBot.attributes_for(:project, name: "New Project Name") }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        patch :update, params: { id: @project.id, project: FactoryBot.attributes_for(:project, name: "New Project Name") }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#destroy" do
    context "ログイン済みユーザーの場合" do
      context "認可されたユーザーの場合" do
        before do
          @user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: @user)
        end

        context "削除に成功する場合" do
          it "ステータスコード303を返すこと" do
            sign_in @user
            delete :destroy, params: { id: @project.id }
            expect(response.status).to eq 303
          end

          it "プロジェクトの削除に成功すること" do
            sign_in @user
            expect {
              delete :destroy, params: { id: @project.id }
            }.to change(@user.projects, :count).by(-1)
          end

          it 'プロジェクト一覧画面にリダイレクトすること' do
            sign_in @user
            delete :destroy, params: { id: @project.id }
            expect(response).to redirect_to(projects_url)
          end

          it "削除成功のフラッシュメッセージが表示されること" do
            sign_in @user
            delete :destroy, params: { id: @project.id }
            expect(flash[:notice]).to eq I18n.t("projects.destroy.success")
          end
        end

        context "削除に失敗する場合" do
          it "ステータスコード303を返すこと" do
            sign_in @user
            allow(Project).to receive(:find).with(@project.id.to_s).and_return(@project)
            allow(@project).to receive(:destroy).and_return(false)
            delete :destroy, params: { id: @project.id }
            expect(response.status).to eq 303
          end

          it "プロジェクトの削除に失敗すること" do
            sign_in @user
            allow(Project).to receive(:find).with(@project.id.to_s).and_return(@project)
            allow(@project).to receive(:destroy).and_return(false)
            expect {
              delete :destroy, params: { id: @project.id }
            }.not_to change(@user.projects, :count)
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            sign_in @user
            allow(Project).to receive(:find).with(@project.id.to_s).and_return(@project)
            allow(@project).to receive(:destroy).and_return(false)
            delete :destroy, params: { id: @project.id }
            expect(response).to redirect_to project_url(assigns(:project))
          end

          it "削除失敗のフラッシュメッセージが表示されること" do
            sign_in @user
            allow(Project).to receive(:find).with(@project.id.to_s).and_return(@project)
            allow(@project).to receive(:destroy).and_return(false)
            delete :destroy, params: { id: @project.id }
            expect(flash[:alert]).to eq I18n.t("projects.destroy.fail")
          end
        end
      end

      context "認可されていないユーザーの場合" do
        before do
          @user = FactoryBot.create(:user)
          other_user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: other_user)
        end

        it "ステータスコード302を返すこと" do
          sign_in @user
          delete :destroy, params: { id: @project.id }
          expect(response).to have_http_status "302"
        end

        it "ルート画面にリダイレクトすること" do
          sign_in @user
          delete :destroy, params: { id: @project.id }
          expect(response).to redirect_to root_path
        end

        it "アクセス権限がない旨のフラッシュメッセージが表示されること" do
          sign_in @user
          delete :destroy, params: { id: @project.id }
          expect(flash[:alert]).to eq I18n.t("errors.access_denied.project")
        end
      end
    end

    context "ログインしていないユーザーの場合" do
      before do
        @project = FactoryBot.create(:project)
      end

      it "ステータスコード302を返すこと" do
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#complete" do
    context "ログイン済みユーザーの場合" do
      context "認可されたユーザーの場合" do
        before do
          @user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: @user, completed: false)
        end

        context "完了処理に成功した場合" do
          it "ステータスコード303を返すこと" do
            sign_in @user
            patch :complete, params: { id: @project.id }
            expect(response).to have_http_status "303"
          end

          it "プロジェクトの完了に成功すること" do
            sign_in @user
            expect {
              patch :complete, params: { id: @project.id }
            }.to change { @project.reload.completed }.from(false).to(true)
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            sign_in @user
            patch :complete, params: { id: @project.id }
            expect(response).to redirect_to project_url(assigns(:project))
          end

          it "完了処理成功のフラッシュメッセージが表示されること" do
            sign_in @user
            patch :complete, params: { id: @project.id }
            expect(flash[:notice]).to eq I18n.t("projects.complete.success")
          end
        end

        context "完了処理に失敗した場合" do
          before do
            allow(Project).to receive(:find).with(@project.id.to_s).and_return(@project)
            allow(@project).to receive(:update).with(completed: true).and_return(false)
          end

          it "ステータスコード303を返すこと" do
            sign_in @user
            patch :complete, params: { id: @project.id }
            expect(response).to have_http_status "303"
          end

          it "プロジェクトの完了に失敗すること" do
            sign_in @user
            expect {
              patch :complete, params: { id: @project.id }
            }.to_not change(@project, :completed)
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            sign_in @user
            patch :complete, params: { id: @project.id }
            expect(response).to redirect_to project_url(assigns(:project))
          end

          it "完了処理失敗のフラッシュメッセージが表示されること" do
            sign_in @user
            patch :complete, params: { id: @project.id }
            expect(flash[:alert]).to eq I18n.t("projects.complete.fail")
          end
        end
      end

      context "認可されていないユーザーの場合" do
        before do
          @user = FactoryBot.create(:user)
          other_user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: other_user, completed: false)
        end

        it "ステータスコード302を返すこと" do
          sign_in @user
          patch :complete, params: { id: @project.id }
          expect(response).to have_http_status "302"
        end

        it 'ルート画面にリダイレクトすること' do
          sign_in @user
          patch :complete, params: { id: @project.id }
          expect(response).to redirect_to root_path
        end

        it "アクセス権限がない旨のフラッシュメッセージが表示されること" do
          sign_in @user
          patch :complete, params: { id: @project.id }
          expect(flash[:alert]).to eq I18n.t("errors.access_denied.project")
        end
      end
    end

    context "ログインしていないユーザーの場合" do
      before do
        @project = FactoryBot.create(:project, completed: false)
      end

      it "ステータスコード302を返すこと" do
        patch :complete, params: { id: @project.id, project: FactoryBot.attributes_for(:project, completed: true) }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        patch :complete, params: { id: @project.id, project: FactoryBot.attributes_for(:project, completed: true) }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
