class AddIndexToTables < ActiveRecord::Migration[6.0]
  def change
    add_index :books, :id
    add_index :books, :title
    add_index :books, :author
    add_index :transactions, :id
  end
end
