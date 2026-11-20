class AddInvitedAllToEvent < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :invited_all, :boolean, null: false, default: true
  end
end
