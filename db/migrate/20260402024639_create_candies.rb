class CreateCandies < ActiveRecord::Migration[8.1]
  def change
    create_table :candies do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.references :brand, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.integer :year_introduced
      t.boolean :discontinued, default: false, null: false

      t.timestamps
    end

    add_index :candies, :slug, unique: true
  end
end
