class AddQyWechatColumnsToQyApps < ActiveRecord::Migration
  def self.up
    create_table(:qy_apps) do |t|
      t.string :name
      t.string :qy_token
      t.string :encoding_aes_key
      t.string :corp_id
      t.string :qy_secret_key
    end
    add_index :qy_apps, :qy_token
    add_index :qy_apps, :encoding_aes_key
    add_index :qy_apps, :corp_id
    add_index :qy_apps, :qy_secret_key
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
