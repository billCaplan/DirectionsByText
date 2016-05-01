class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id, null: false
      t.text :favorite_label, null: false
      t.text :favorite_address, null: false
      t.text :url_ready_address
      t.timestamps null: false
    end
  end
end
