class CreateEventTopics < ActiveRecord::Migration[8.1]
  def change
    create_table :event_topics do |t|
      t.string :key
      t.string :description

      t.timestamps
    end

    add_index :event_topics, :key, unique: true
  end
end
