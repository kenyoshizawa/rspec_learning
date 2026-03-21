require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "#top" do
    it "ステータスコード200を返すこと" do
      get :top
      expect(response).to have_http_status "200"
    end

    it "topテンプレートをレンダリングすること" do
      get :top
      expect(response).to render_template :top
    end
  end
end
