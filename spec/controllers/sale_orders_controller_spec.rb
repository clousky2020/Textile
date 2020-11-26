require 'rails_helper'

RSpec.describe SaleOrdersController, type: :controller do
  let(:user) {create(:user)}
  let(:sale_customer) {create(:sale_customer)}
  let(:product) {create(:product)}
  let!(:repo) {create(:repo, user: user)}
  before do
    login(user)
  end

  describe "GET index" do
    it "assigns @sale_orders" do
      sale_order = create(:sale_order, sale_customer: sale_customer, user: user, repo: repo, product: product)
      get :index
      expect(assigns(:sale_orders)).to eq([sale_order])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

end
