class AddIndexOnCandiesDiscontinued < ActiveRecord::Migration[8.1]
  def change
    add_index :candies, :discontinued
  end
end
