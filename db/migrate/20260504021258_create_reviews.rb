class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :candy, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :body, null: false

      t.timestamps
    end

    add_index :reviews, %i[user_id candy_id], unique: true
  end
end
