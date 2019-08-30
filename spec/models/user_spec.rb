require 'rails_helper'

RSpec.describe User, type: :model do
  describe "属性に問題があるuserとして" do
    it "要素が全て空であれば保存に失敗すること" do
      user = User.new
      expect(user).to_not be_valid
    end

    it "nameが空であれば保存に失敗すること" do
      user = create(:user)
      user.update(name: nil)
      expect(user).to_not be_valid
    end

    it "nameは５０文字以上だと保存に失敗すること" do
      user = create(:user)
      user.update(name: "a"*51)
      expect(user).to_not be_valid
    end

    it "emailが無効な値であれば失敗すること" do
      user = build(:user, email: "hogehoge")
      expect(user).to_not be_valid
    end

    it "passwordの文字数が６文字未満だと失敗すること" do
      user = build(:user, password: "12345")
      expect(user).to_not be_valid
    end

  end

  describe "有効な属性値を持ったユーザーとして" do
    before(:each) do
      @user = create(:user)
    end

    it "有効な属性を持っているんだからテストにパスすること" do
      expect(@user).to be_valid
    end

    it "emailが一意でないと失敗すること" do
      user = User.new(name: "ユーザー２", email: "example1@gmail.com")
      expect(user).to_not be_valid
    end
  end



end
