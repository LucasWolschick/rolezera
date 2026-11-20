class CreateEventDraftInvites < ActiveRecord::Migration[8.1]
  def change
    create_table :event_draft_invites do |t|
      t.references :event_draft, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :event_draft_invites, [ :event_draft_id, :user_id ], unique: true
  end
end
