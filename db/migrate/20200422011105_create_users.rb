class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :username, null: false, unique: true
      t.text :info

      t.timestamps
    end
  end
end
