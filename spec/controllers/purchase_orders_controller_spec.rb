require 'rails_helper'

RSpec.describe PurchaseOrdersController, type: :controller do
  let(:user) {create(:user)}
  let(:purchase_supplier) {create(:purchase_supplier)}
  let(:material) {create(:material, purchase_supplier: purchase_supplier)}
  let!(:repo) {create(:repo, user: user)}
  before do
    login(user)
  end

  describe "GET index" do
    it "assigns @purchase_orders" do
      purchase_orders = create(:purchase_order, purchase_supplier: purchase_supplier, user: user, repo: repo, material: material)
      get :index
      expect(assigns(:purchase_orders)).to eq([purchase_orders])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

end
