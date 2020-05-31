class CreateFriendshipRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :friendship_requests do |t|
      t.belongs_to :requestor, class_name: 'User'
      t.belongs_to :receiver, class_name: 'User'

      t.timestamps
    end

    add_index :friendship_requests, [:requestor_id, :receiver_id], unique: true
  end
end
