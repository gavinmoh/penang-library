class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books, id: :uuid do |t|
      t.string :title, length: 255
      t.string :author, length: 255
      t.integer :published_year, length: 10
      t.string :serial_number, length: 255
      t.string :genre, length: 255

      t.timestamps
    end
  end
end
