class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :name
      t.string :image
      t.integer :giver_id
      t.integer :taker_id
      t.integer :isbn
      t.integer :message_id

      t.timestamps
    end
  end
end
