class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :image
      t.integer :book_id
      t.integer :giver_id
      t.integer :taker_id
      t.text :content

      t.timestamps
    end
  end
end
