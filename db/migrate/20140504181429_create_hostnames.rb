class CreateHostnames < ActiveRecord::Migration
  def change
    create_table :hostnames do |t|
      t.string :name
      t.integer :user_id
      t.integer :status, default: 0
      t.string :ipaddress

      t.timestamps
    end
  end
end
