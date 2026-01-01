class CreateEventTopics < ActiveRecord::Migration[8.1]
  def change
    create_table :event_topics do |t|
      t.string :key, null: false
      t.string :description, null: false
      t.string :prompt, null: false

      t.timestamps
    end

    add_index :event_topics, :key, unique: true
  end
end
