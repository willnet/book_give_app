require 'rails_helper'

RSpec.feature "Books", type: :feature do

  feature "ログインしていない場合のアクセス制限がかかっているかどうか" do
    scenario "new_giveページへのアクセス制限" do
      visit root_path
      visit book_new_give_path
      expect(page).to have_content "アカウント登録もしくはログインしてください"
    end

    scenario "send_offerページへのアクセス制限" do
      visit root_path
      visit book_send_offer_path
      expect(page).to have_content "アカウント登録もしくはログインしてください"
    end
  end

  feature "searchページ周り" do
    before(:each) do
      @book = create(:book)
    end

    scenario "Searchページのviewが正常に表示されていること" do
      user = User.create(name: "ジョンソン")
      visit root_path
      click_link "こちらのページ"
      save_and_open_page
      expect(page).to have_content "Search"
      expect(current_path).to eq book_search_results_path
      expect(page).to have_content "残酷な"
    end

  end



  feature "new_giveページ周り" do
    before(:each) do
      @user = create(:user)
    end

    #javascriptが動くようになったら要テスト
    # scenario "new_giveページでisbnを入力すると書籍情報が取得できること" do
    #   visit root_path
    #   log_in @user
    #   visit book_new_give_path
    #   fill_in "isbn", with: "4794221789"
    #   click_button "本を検索する"
    #   # save_and_open_page
    #   expect(page).to have_content "マインドセット"
    # end
  end


end
