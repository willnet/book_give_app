require 'rails_helper'

RSpec.describe Book, type: :model do
  before(:each) do
    @book = build(:book)
  end

  describe "属性に問題があるbookとして" do
    it "要素がすべて空であれば保存に失敗すること" do
      book = Book.new
      expect(book).to_not be_valid
    end

    it "nameが空であれば保存に失敗すること" do
      @book.update(name: nil)
      expect(@book).to_not be_valid
    end

    it "isbnが空であれば保存に失敗すること" do
      @book.update(isbn: nil)
      expect(@book).to_not be_valid
    end

    it "giver_idが空であれば保存に失敗すること" do
      @book.update(giver_id: nil)
      expect(@book).to_not be_valid
    end
  end

  describe "有効な値を持ったbookとして" do

    it "有効な属性値を持っているのでテストにパスすること" do
      expect(@book).to be_valid
    end

  end
end
