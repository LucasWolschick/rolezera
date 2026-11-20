class CreateFriendInvites < ActiveRecord::Migration[8.1]
  def change
    create_table :friend_invites do |t|
      t.references :inviter, null: false, foreign_key: { to_table: :users }
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.datetime :created_at, null: false
    end

    add_index :friend_invites, :token, unique: true
    add_index :friend_invites, :expires_at
  end
end
