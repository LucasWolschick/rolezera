class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :inviter, null: false, foreign_key: { to_table: :users }
      t.references :event_topic, null: false, foreign_key: true
      t.datetime :expires_at

      t.timestamps
    end

    add_index :events, :expires_at
  end
end
