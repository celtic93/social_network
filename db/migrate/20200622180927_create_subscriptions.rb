class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :subscriber, class_name: 'User'
      t.belongs_to :publisher, polymorphic: true
      
      t.timestamps
    end
  end
end
