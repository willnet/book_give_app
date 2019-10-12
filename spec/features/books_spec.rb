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
      @user = create(:user)
      @book1 = Book.create(name: "テスト用の本です1", isbn: 1234555,giver_id: @user.id)
      @book2 = Book.create(name: "テスト用の本です2", isbn: 1234555,giver_id: @user.id)
    end

    scenario "Searchページのviewが正常に表示されていること" do
      visit root_path
      click_link "こちらのページ"
      expect(page).to have_content "Search"
      expect(current_path).to eq book_search_results_path
      expect(page).to have_content "テスト用の本です1"
      expect(page).to have_content "テスト用の本です2"
    end

    scenario "Giveされている本の絞り込み機能が正常に動くこと" do
      visit root_path
      click_link "こちらのページ"
      fill_in "search", with: "テスト用の本です1"
      click_on "Search"
      expect(page).to have_content "テスト用の本です1"
      expect(page).to_not have_content "テスト用の本です2"
    end
  end

  feature "Registeredページ周り" do
    before(:each) do
      @user = create(:user)
      @book1 = Book.create(name: "テスト用の本です1", isbn: 1234555,giver_id: @user.id)
      @book2 = Book.create(name: "テスト用の本です2", isbn: 1234555,giver_id: @user.id)
    end

    scenario "登録してある本がしっかり表示されるviewになっていること" do
      visit root_path
      log_in @user
      click_link "オファー受付中のあなたの本"
      expect(page).to have_content "Registered"
      expect(page).to have_content "#{@user.name}さんは以下の本を登録済みです。"
      expect(page).to have_content "テスト用の本です1"
      expect(page).to have_content "テスト用の本です2"
    end

    scenario "登録してある本が正常に削除されること" do
      visit root_path
      log_in @user
      click_link "オファー受付中のあなたの本"
      expect{click_link "削除する",match: :first}.to change{Book.count}.by(-1)
      expect(current_path).to eq root_path
      expect(page).to have_content "削除に成功しました"

      #削除された本がもう表示されていないことも確認する
      click_link "マイページ"
      click_link "オファー受付中のあなたの本"
      expect(page).to_not have_content "テスト用の本です1"
      expect(page).to have_content "テスト用の本です2"
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
