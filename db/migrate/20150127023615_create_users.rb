class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :userid
      t.string :deviceid
      t.string :position
      t.string :mobile
      t.integer :gender
      t.string :email
      t.string :wexinid
      t.integer :status

      t.timestamps
    end
  end
end
