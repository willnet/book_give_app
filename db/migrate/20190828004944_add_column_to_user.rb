class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :image, :string
    add_column :users, :address, :string
    add_column :users, :admin, :boolean
    add_column :users, :give_count, :integer
    add_column :users, :take_count, :integer
    add_column :users, :took_books, :string
    add_column :users, :now_give_books, :string
    add_column :users, :already_give_books, :string
  end
end
