class CreateCastMembers < ActiveRecord::Migration
  def change
    create_table :cast_members do |t|
      t.integer :movie_id, null: false
      t.integer :actor_id, null: false
      t.string :character

      t.timestamps
    end

    add_index :cast_members, :movie_id
    add_index :cast_members, :actor_id
  end
end
