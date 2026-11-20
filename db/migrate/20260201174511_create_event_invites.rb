class CreateEventInvites < ActiveRecord::Migration[8.1]
  def change
    create_table :event_invites do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :event_invites, [ :event_id, :user_id ], unique: true
  end
end
