class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :qy_group_id

      t.timestamps
    end
  end
end
