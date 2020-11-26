require 'rails_helper'

describe "repo" do
  let(:user) {create(:user)}
  let(:repo) {build(:repo)}
  before(:each) do
    login_in(user)
  end
  describe "创建仓库" do
    it "一个新的仓库" do
      visit '/'
      click_link '生产资料'
      click_link "仓库管理"
      click_link "新建"
      fill_in "repo[name]", with: repo.name
      fill_in "repo[address]", with: repo.address
      fill_in "repo[description]", with: repo.description
      select user.name, from: "管理员"
      click_button "创建"
      expect(page).to have_content("创建成功")
      visit '/repos'
      expect(page).to have_content(repo.name)
    end
  end

  describe "删除仓库" do
    it "不能删除最后一个仓库" do
      repo = create(:repo, user: user)
      purchase_supplier = create(:purchase_supplier)
      material = create(:material, purchase_supplier: purchase_supplier)
      purchase_order = create(:purchase_order, repo: repo, user: user, purchase_supplier: purchase_supplier, material: material)
      visit '/repos'
      expect(page).to have_content(repo.name)
      el = find("a", text: repo.name).find(:xpath, "./../../td[3]/a[2]")
      el.click
      expect(page).to have_content('最后一个仓库不能删除')
      expect(page).to have_content(repo.name)
    end

    it "不能删除有订单关联的仓库" do
      repo = create(:repo, user: user)
      repo_2 = create(:repo, user: user)
      purchase_supplier = create(:purchase_supplier)
      material = create(:material, purchase_supplier: purchase_supplier)
      purchase_order = create(:purchase_order, repo: repo, user: user, purchase_supplier: purchase_supplier, material: material)
      visit '/repos'
      expect(page).to have_content(repo.name)
      el = find("a", text: repo.name).find(:xpath, "./../../td[3]/a[2]")
      el.click
      expect(page).to have_content("不能删除")
      expect(page).to have_content(repo.name)
    end
  end

end
