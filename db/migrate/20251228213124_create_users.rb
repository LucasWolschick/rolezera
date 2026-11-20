class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :google_sub, null: false

      t.string :name
      t.string :phone

      t.timestamps
    end

    add_index :users, [ :email ], unique: true
    add_index :users, [ :google_sub ], unique: true
  end
end
