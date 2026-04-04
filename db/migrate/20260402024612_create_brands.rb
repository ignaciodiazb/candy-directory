class CreateBrands < ActiveRecord::Migration[8.1]
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :country_of_origin, default: "Chile"

      t.timestamps
    end

    add_index :brands, :name, unique: true
    add_index :brands, :slug, unique: true
  end
end
