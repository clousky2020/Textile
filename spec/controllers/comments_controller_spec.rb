require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) {create(:user)}
  before do
    login(user)
  end

  describe "GET index" do
    it "assigns @comments" do
      comment = create(:comment, user: user)
      get :index
      expect(assigns(:comments)).to eq([comment])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

end
