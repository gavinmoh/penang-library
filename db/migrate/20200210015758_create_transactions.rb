class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :book, null: false, foreign_key: true, type: :uuid
      t.timestamp :checkout_timestamp, null: false
      t.timestamp :checkin_timestamp
      t.timestamp :due_timestamp, null: false

      t.timestamps
    end
  end
end
