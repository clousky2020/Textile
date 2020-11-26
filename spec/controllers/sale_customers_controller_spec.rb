require 'rails_helper'

RSpec.describe SaleCustomersController, type: :controller do
  let(:user) {create(:user)}
  let(:sale_customer) {create(:sale_customer)}

  before do
    login(user)
  end

  describe "GET index" do
    it "assigns @sale_customers" do
      sale_customer = create(:sale_customer)
      get :index
      expect(assigns(:sale_customers)).to eq([sale_customer])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

end
