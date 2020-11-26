require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  let(:user) {create(:user)}
  let(:purchase_supplier) {create(:purchase_supplier)}
  before do
    login(user)
  end

  describe "GET index" do
    it "assigns @expenses" do
      expense = create(:expense, counterparty: purchase_supplier, user: user)
      get :index
      expect(assigns(:expenses)).to eq([expense])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

end
