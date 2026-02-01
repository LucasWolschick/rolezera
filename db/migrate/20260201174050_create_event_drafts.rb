class CreateEventDrafts < ActiveRecord::Migration[8.1]
  def change
    create_table :event_drafts do |t|
      t.references :inviter, null: false, foreign_key: { to_table: :users }, index: { unique: true }
      t.references :event_topic, null: true, foreign_key: true
      t.boolean :invited_all, null: false, default: false

      t.timestamps
    end
  end
end
