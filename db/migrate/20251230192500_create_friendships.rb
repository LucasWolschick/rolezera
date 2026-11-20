class CreateFriendships < ActiveRecord::Migration[8.1]
  def change
    create_table :friendships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_check_constraint :friendships, "user_id != friend_id", name: "friendships_no_self_friends"
    add_index :friendships, [ :user_id, :friend_id ], unique: true

    add_column :users, :friends_count, :integer, null: false, default: 0
  end
end
