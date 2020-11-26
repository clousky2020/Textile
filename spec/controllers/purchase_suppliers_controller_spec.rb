require 'rails_helper'

RSpec.describe PurchaseSuppliersController, type: :controller do
  let(:user) {create(:user)}
  let(:purchase_supplier) {create(:purchase_supplier)}

  before do
    login(user)
  end

  describe "GET index" do
    it "assigns @purchase_suppliers" do
      purchase_suppliers = create(:purchase_supplier)
      get :index
      expect(assigns(:purchase_suppliers)).to eq([purchase_suppliers])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

end
