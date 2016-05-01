class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.integer :user_id, null:false
      t.text :query, null:false
      t.timestamps null: false
    end
  end
end
