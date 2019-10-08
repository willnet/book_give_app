require 'rails_helper'

RSpec.describe Message, type: :model do

  describe "Messageのバリデーションがうまくいっていること" do

    before(:each) do
      @message = Message.new(content: "これは正常なインスタンスになるはずです",
                             book_id: 1, giver_id: 1, taker_id: 2)
    end

    it "値が正常ならインスタンスも有効になること" do
      expect(@message).to be_valid
    end
    it "contentが空なら失敗すること" do
      @message.update(content: nil)
      expect(@message).to_not be_valid
    end
    it "contentが８００字以上なら失敗すること" do
      @message.update(content: "a"*801)
      expect(@message).to_not be_valid
    end
    it "contentが８００文字以下なら有効であること" do
      @message.update(content: "a"*799)
      expect(@message).to be_valid
    end
    it "book_idが空なら失敗すること" do
      @message.update(book_id: nil)
      expect(@message).to_not be_valid
    end
  end
end
