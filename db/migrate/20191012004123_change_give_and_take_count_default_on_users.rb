class ChangeGiveAndTakeCountDefaultOnUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :give_count, from: nil, to: 0
    change_column_default :users, :take_count, from: nil, to: 0
  end
end
