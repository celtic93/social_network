class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.belongs_to :friend_a, class_name: 'User'
      t.belongs_to :friend_b, class_name: 'User'

      t.timestamps
    end

    add_index :friendships, [:friend_a_id, :friend_b_id], unique: true
  end
end
