require 'rails_helper'

RSpec.describe SaleCustomer, type: :model do
  it "创建一个客户" do
    expect(create(:sale_customer)).to be_truthy
  end

end
