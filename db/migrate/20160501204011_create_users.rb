class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :phonenumber, null: false
      t.timestamps null: false
    end
  end
end
