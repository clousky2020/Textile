require 'rails_helper'

describe "comment" do
  let(:user) {create(:user)}

  before do
    login_in(user)
  end

  describe "发一条建议" do
    it '页面中出现这条' do
      visit comments_url
      expect(page).to have_content("反馈评论")
      fill_in "comment[content]", with: "测试内容"
      click_button "发布"
      expect(page).to have_content("测试内容")
    end
  end
  describe "删除一条建议" do
    it '这条内容不会出现在页面上了' do
      comment_1 = create(:comment, user: user)
      comment_2 = create(:comment, user: user)
      comment_3 = create(:comment, user: user)
      visit comments_path
      expect(page).to have_content("反馈评论")
      el = find("p", text: comment_1.content).find(:xpath, "./../div/p/span[2]/a")
      el.click
      # page.driver.browser.switch_to.alert.accept
      expect(page).not_to have_content(comment_1.content)
    end
  end

end
